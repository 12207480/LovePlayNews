//
//  LPNewsListViewController.m
//  LovePlayNews
//
//  Created by tany on 16/8/3.
//  Copyright © 2016年 tany. All rights reserved.
//

#import "LPNewsListController.h"
#import "LPGameNewsOperation.h"
#import "LPNewsCellNode.h"
#import "LPNewsImageCellNode.h"
#import "LPNewsImageTitleCellNode.h"
#import "LPNewsDetailController.h"
#import "LPRefreshGifHeader.h"
#import "LPLoadingView.h"
#import "LPLoadFailedView.h"

@interface LPNewsListController ()<ASTableDelegate, ASTableDataSource>

// UI
@property (nonatomic, strong) ASTableNode *tableNode;

// Data
@property (nonatomic, strong) NSArray *newsList;
@property (nonatomic, assign) NSInteger curIndexPage;
@property (nonatomic, assign) BOOL haveMore;

@end

@implementation LPNewsListController

#pragma mark - life cycle

- (instancetype)init
{
    if (self = [super initWithNode:[ASDisplayNode new]]) {
        _sourceType = 1;
        [self addTableNode];
    }
    return self;
}

- (void)addTableNode
{
    _tableNode = [[ASTableNode alloc] init];
    _tableNode.backgroundColor = [UIColor whiteColor];
    _tableNode.delegate = self;
    _tableNode.dataSource = self;
    [self.node addSubnode:_tableNode];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self configureTableView];
    
    [self addRefreshHeader];
    
    [self loadData];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    _tableNode.frame = self.node.bounds;
}

- (void)configureTableView
{
    if (_extendedTabBarInset) {
        _tableNode.view.contentInset = UIEdgeInsetsMake(0, 0, 49, 0);
        _tableNode.view.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 49, 0);
    }
    _tableNode.frame = self.node.bounds;
    _tableNode.view.tableFooterView = [[UIView alloc]init];
    _tableNode.view.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)addRefreshHeader
{
    LPRefreshGifHeader *header = [LPRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    _tableNode.view.ty_refreshHeader = header;
}

// 显示更新新闻条数
- (void)showUpdateNewsCountView:(NSInteger)count
{
    CGFloat labelH = 25;
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), -labelH)];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = [NSString stringWithFormat:@"发现%zd条新内容",count];
    label.font = [UIFont systemFontOfSize:12];
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = RGBA_255(238, 95, 112, 0.8);
    [self.view insertSubview:label aboveSubview:_tableNode.view];
    
    // 移动动画
    [UIView animateWithDuration:0.5 animations:^{
        label.transform = CGAffineTransformMakeTranslation(0, labelH);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.5 delay:1.0 options:UIViewAnimationOptionCurveLinear animations:^{
            label.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            [label removeFromSuperview];
        }];
    }];
}

#pragma mark - load Data

- (void)loadData
{
    NSInteger curIndexPage = _curIndexPage;
    curIndexPage = 0;
    _haveMore = YES;
    if (!_newsList) {
        [LPLoadingView showLoadingInView:self.view];
    }
    
    LPHttpRequest *newsListRequest = [LPGameNewsOperation requestNewsListWithTopId:_newsTopId pageIndex:curIndexPage];
    [newsListRequest loadWithSuccessBlock:^(LPHttpRequest *request) {
        NSArray *newsList = request.responseObject.data;
        // 加载最新
        if (_newsList.count == 0) {
            _newsList = request.responseObject.data;
            [_tableNode.view reloadData];
            _curIndexPage++;
            [LPLoadingView hideLoadingForView:self.view];
        }else {
            LPNewsInfoModel *infoModel = _newsList.firstObject;
            NSMutableArray *indexPaths = [NSMutableArray array];
            NSInteger index = 0;
            for (LPNewsInfoModel *newInfoModel in newsList) {
                if ([newInfoModel.docid isEqualToString:infoModel.docid]) {
                    break;
                }
                [indexPaths addObject:[NSIndexPath indexPathForRow:index inSection:0]];
                ++index;
            }
            if (indexPaths.count > 0) {
                NSArray *newAddList = [newsList objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, index)]];
                _newsList = [newAddList arrayByAddingObjectsFromArray:_newsList];
                [_tableNode.view insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationTop];
                [self showUpdateNewsCountView:newAddList.count];
            }
        }
        _haveMore = YES;
        [_tableNode.view.ty_refreshHeader endRefreshing];
    }failureBlock:^(id<TYRequestProtocol> request, NSError *error) {
        [_tableNode.view.ty_refreshHeader endRefreshing];
        [LPLoadingView hideLoadingForView:self.view];
        if (_newsList.count == 0) {
            __weak typeof(self) weakSelf = self;
            [LPLoadFailedView showLoadFailedInView:self.view retryHandle:^{
                [weakSelf loadData];
            }];
        }
    }];
}

- (void)loadMoreDataWithContext:(ASBatchContext *)context
{
    if (context) {
        [context beginBatchFetching];
    }
    
    LPHttpRequest *newsListRequest = [LPGameNewsOperation requestNewsListWithTopId:_newsTopId pageIndex:_curIndexPage];
    [newsListRequest loadWithSuccessBlock:^(LPHttpRequest *request) {
        NSArray *newsList = request.responseObject.data;
        if (context) {
            // 加载更多
            if (newsList.count > 0) {
                NSMutableArray *indexPaths = [NSMutableArray array];
                for (NSInteger row = _newsList.count; row<_newsList.count+newsList.count; ++row) {
                    [indexPaths addObject:[NSIndexPath indexPathForRow:row inSection:0]];
                }
                _newsList = [_newsList arrayByAddingObjectsFromArray:newsList];
                [_tableNode.view insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
                _curIndexPage++;
                _haveMore = YES;
            }else {
                _haveMore = NO;
            }
        }
        if (context) {
            [context completeBatchFetching:YES];
        }
    } failureBlock:^(id<TYRequestProtocol> request, NSError *error) {
        if (context) {
            [context completeBatchFetching:YES];
        }
    }];
}

#pragma mark - ASTableDataSource

- (BOOL)shouldBatchFetchForTableView:(ASTableView *)tableView
{
    return _newsList.count && _haveMore;
}

- (void)tableView:(ASTableView *)tableView willBeginBatchFetchWithContext:(ASBatchContext *)context
{
    [self loadMoreDataWithContext:context];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _newsList.count;
}

- (ASCellNodeBlock)tableView:(ASTableView *)tableView nodeBlockForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LPNewsInfoModel *newsInfo = _newsList[indexPath.row];
    ASCellNode *(^cellNodeBlock)() = ^ASCellNode *() {
        LPNewsBaseCellNode *cellNode = nil;
        if (_sourceType == 0) {
            cellNode = [[LPNewsImageTitleCellNode alloc] initWithNewsInfo:newsInfo];
        }else {
            switch (newsInfo.showType) {
                case 2:
                    cellNode = [[LPNewsImageCellNode alloc] initWithNewsInfo:newsInfo];
                    break;
                default:
                    cellNode = [[LPNewsCellNode alloc] initWithNewsInfo:newsInfo];
                    break;
            }
        }
        return cellNode;
    };
    return cellNodeBlock;
}

#pragma mark - ASTableDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    LPNewsInfoModel *newsInfo = _newsList[indexPath.row];
    LPNewsDetailController *detail = [[LPNewsDetailController alloc]init];
    detail.newsId = newsInfo.docid;
    [self.navigationController pushViewController:detail animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
