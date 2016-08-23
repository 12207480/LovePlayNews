//
//  LPNewsListViewController.m
//  LovePlayNews
//
//  Created by tany on 16/8/3.
//  Copyright © 2016年 tany. All rights reserved.
//

#import "LPNewsListController.h"
#import "LPNewsInfoOperation.h"
#import "MBProgressHUD+MJ.h"
#import "LPNewsCellNode.h"
#import "LPNewsImageCellNode.h"
#import "LPNewsDetailController.h"
#import "LPRefreshGifHeader.h"

@interface LPNewsListController ()<ASTableDelegate, ASTableDataSource>

// UI
@property (nonatomic, strong) ASTableNode *tableNode;

// Data
@property (nonatomic, strong) NSArray *newsList;

@property (nonatomic, assign) NSInteger curIndexPage;
@property (nonatomic, assign) BOOL haveMore;

@end

@implementation LPNewsListController

- (instancetype)init
{
    _tableNode = [[ASTableNode alloc] init];
    if (self = [super initWithNode:_tableNode]) {
        _tableNode.delegate = self;
        _tableNode.dataSource = self;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    _tableNode.view.tableFooterView = [[UIView alloc]init];
    _tableNode.view.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    LPRefreshGifHeader *header = [LPRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    _tableNode.view.mj_header = header;
    [header beginRefreshing];
}

#pragma mark - load Data

- (void)loadData
{
    [self loadMoreDataWithContext:nil];
}

- (void)loadMoreDataWithContext:(ASBatchContext *)context
{
    if (context) {
        [context beginBatchFetching];
    }else {
        _curIndexPage = 0;
        _haveMore = YES;
    }
    
    LPHttpRequest *newsListRequest = [LPNewsInfoOperation requestNewsListWithTopId:_newsTopId pageIndex:_curIndexPage];
    [newsListRequest loadWithSuccessBlock:^(LPHttpRequest *request) {
        NSArray *newsList = request.responseObject.data;
        if (_newsList.count > 0) {
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
        }else {
           _newsList = request.responseObject.data;
            [_tableNode.view reloadData];
            _curIndexPage++;
            _haveMore = YES;
        }
        
        if (context) {
            [context completeBatchFetching:YES];
        }else {
            [_tableNode.view.mj_header endRefreshing];
        }
    } failureBlock:^(id<TYRequestProtocol> request, NSError *error) {
        if (context) {
            [context completeBatchFetching:YES];
        }else {
            [_tableNode.view.mj_header endRefreshing];
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
        switch (newsInfo.showType) {
            case 2:
                cellNode = [[LPNewsImageCellNode alloc] initWithNewsInfo:newsInfo];
                break;
            default:
                cellNode = [[LPNewsCellNode alloc] initWithNewsInfo:newsInfo];
                break;
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
