//
//  LPNewsCommentController.m
//  LovePlayNews
//
//  Created by tanyang on 16/8/20.
//  Copyright © 2016年 tany. All rights reserved.
//

#import "LPNewsCommentController.h"
#import "LPNavigationBarView.h"
#import "UIView+Nib.h"
#import "LPNewsCommentOperation.h"
#import "MBProgressHUD+MJ.h"
#import "LPNewsCommentCellNode.h"
#import "LPNewsTitleSectionView.h"

@interface LPNewsCommentController ()<ASTableDelegate, ASTableDataSource>

// UI
@property (nonatomic, strong) ASTableNode *tableNode;
@property (nonatomic, weak) LPNavigationBarView *navBar;

// Data
@property (nonatomic, strong) LPNewsCommentModel *hotComments;
@property (nonatomic, strong) LPNewsCommentModel *newestComments;

@property (nonatomic, assign) NSInteger curIndexPage;
@property (nonatomic, assign) BOOL haveMore;

@end

static NSString *headerId = @"LPNewsTitleSectionView";

@implementation LPNewsCommentController

- (instancetype)init
{
    if (self = [super initWithNode:[ASDisplayNode new]]) {
        
        [self addTableNode];
    }
    return self;
}

- (void)addTableNode
{
    _tableNode = [[ASTableNode alloc] init];
    _tableNode.backgroundColor = RGB_255(247, 247, 247);
    _tableNode.delegate = self;
    _tableNode.dataSource = self;
    [self.node addSubnode:_tableNode];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self configureController];
    
    [self addNavBarView];
    
    [self configureTableView];
    
    [self loadData];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    _navBar.frame = CGRectMake(0, 0, CGRectGetWidth(self.node.frame), kNavBarHeight);
    _tableNode.frame = CGRectMake(0, kNavBarHeight, CGRectGetWidth(self.node.frame), CGRectGetHeight(self.node.frame) - kNavBarHeight);
}

- (void)configureController
{
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)addNavBarView
{
    LPNavigationBarView *navBar = [LPNavigationBarView loadInstanceFromNib];
    [self.node.view addSubview:navBar];
    _navBar = navBar;
}

- (void)configureTableView
{
    _tableNode.view.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableNode.view.tableFooterView = [[UIView alloc]init];
    
    [_tableNode.view registerClass:[LPNewsTitleSectionView class] forHeaderFooterViewReuseIdentifier:headerId];
}

#pragma mark - load Data

- (void)loadData
{
    [MBProgressHUD showMessage:@"加载中..." toView:self.view];
    LPHttpRequest *hotCommentsRequest = [LPNewsCommentOperation requestHotCommentWithNewsId:_newsId];
    
    _curIndexPage = 0;
    _haveMore = YES;
    LPHttpRequest *newCommentsRequest = [LPNewsCommentOperation requestNewCommentWithNewsId:_newsId pageIndex:_curIndexPage];
    
    TYBatchRequest *batchRequest = [[TYBatchRequest alloc]init];
    [batchRequest addRequestArray:@[hotCommentsRequest,newCommentsRequest]];
    [batchRequest loadWithSuccessBlock:^(TYBatchRequest *request) {
        if (request.requestCompleteCount >=2) {
            LPHttpRequest *hotRequest = request.batchRequstArray[0];
            LPHttpRequest *newRequest = request.batchRequstArray[1];
            _hotComments = hotRequest.responseObject.data;
            _newestComments = newRequest.responseObject.data;

            [_tableNode.view reloadData];
            ++_curIndexPage;
            _haveMore = YES;
        }
        [MBProgressHUD hideHUDForView:self.view];
    } failureBlock:^(TYBatchRequest *request, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view];
    }];
}

- (void)loadMoreDataWithContext:(ASBatchContext *)context
{
    if (context) {
        [context beginBatchFetching];
    }
    
    LPHttpRequest *newCommentsRequest = [LPNewsCommentOperation requestNewCommentWithNewsId:_newsId pageIndex:_curIndexPage];
    [newCommentsRequest loadWithSuccessBlock:^(LPHttpRequest *request) {
        LPNewsCommentModel *newestComments = request.responseObject.data;
        if (newestComments.commentIds.count > 0) {
            
            NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:_newestComments.comments];
            [dic addEntriesFromDictionary:newestComments.comments];
            _newestComments.comments  = [dic copy];
            
            NSMutableArray *indexPaths = [NSMutableArray array];
            for (NSInteger row = newestComments.commentIds.count; row<_newestComments.commentIds.count+newestComments.commentIds.count; ++row) {
                [indexPaths addObject:[NSIndexPath indexPathForRow:row inSection:1]];
            }
            
            _newestComments.commentIds = [_newestComments.commentIds arrayByAddingObjectsFromArray:newestComments.commentIds];
            
            [_tableNode.view insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
            _curIndexPage++;
            _haveMore = YES;
        }else {
            _haveMore = NO;
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
    return _newestComments.commentIds.count > 0 && _haveMore;
}

- (void)tableView:(ASTableView *)tableView willBeginBatchFetchWithContext:(ASBatchContext *)context
{
    [self loadMoreDataWithContext:context];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _hotComments.commentIds.count > 0 || _newestComments.commentIds.count > 0 ? 2 : 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return _hotComments.commentIds.count;
        case 1:
            return _newestComments.commentIds.count;
        default:
            return 0;
    }
}

- (ASCellNodeBlock)tableView:(ASTableView *)tableView nodeBlockForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *floors = indexPath.section == 0 ? _hotComments.commentIds[indexPath.row] :_newestComments.commentIds[indexPath.row];
    NSDictionary *comments = indexPath.section == 0 ? _hotComments.comments : _newestComments.comments;
    ASCellNode *(^commentCellNodeBlock)() = ^ASCellNode *() {
        LPNewsCommentCellNode *cellNode = [[LPNewsCommentCellNode alloc] initWithCommentItems:comments floors:floors];
        return cellNode;
    };
    return commentCellNodeBlock;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (_hotComments.commentIds.count == 0 && section == 0) {
        return nil;
    }else if (_newestComments.commentIds.count == 0 && section == 1) {
        return nil;
    }
    
    LPNewsTitleSectionView *sectionView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:headerId];
    
    switch (section) {
        case 0:
            sectionView.title = @"热门跟帖";
            break;
        case 1:
            sectionView.title = @"最新跟帖";
            break;
        default:
            break;
    }
    
    return sectionView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (_hotComments.commentIds.count > 0 && section == 0) {
        return 28;
    }else if (_newestComments.commentIds.count > 0 && section == 1) {
        return 28;
    }
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
