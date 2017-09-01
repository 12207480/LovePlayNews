//
//  LPNewsCommentController.m
//  LovePlayNews
//
//  Created by tanyang on 16/8/20.
//  Copyright © 2016年 tany. All rights reserved.
//

#import "LPNewsCommentController.h"
#import "LPNewsCommentOperation.h"
#import "LPNewsCommentCellNode.h"
#import "LPNewsTitleSectionView.h"
#import "LPLoadingView.h"
#import "LPLoadFailedView.h"

@interface LPNewsCommentController ()<ASTableDelegate, ASTableDataSource>

// UI
@property (nonatomic, strong) ASTableNode *tableNode;

// Data
@property (nonatomic, strong) LPNewsCommentModel *hotComments;
@property (nonatomic, strong) LPNewsCommentModel *newestComments;

@property (nonatomic, assign) NSInteger curIndexPage;
@property (nonatomic, assign) BOOL haveMore;

@end

static NSString *headerId = @"LPNewsTitleSectionView";

@implementation LPNewsCommentController

#pragma mark - life cycle

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
    self.title = @"更多评论";
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view layoutIfNeeded];
    
    [self configureTableView];
    
    [self loadData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    _tableNode.frame = self.node.bounds;
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
    [LPLoadingView showLoadingInView:self.view];
    LPHttpRequest *hotCommentsRequest = [LPNewsCommentOperation requestHotCommentWithNewsId:_newsId];
    
    _curIndexPage = 0;
    _haveMore = YES;
    LPHttpRequest *newCommentsRequest = [LPNewsCommentOperation requestNewCommentWithNewsId:_newsId pageIndex:_curIndexPage pageSize:12];
    
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
        [LPLoadingView hideLoadingForView:self.view];
    } failureBlock:^(TYBatchRequest *request, NSError *error) {
        [LPLoadingView hideLoadingForView:self.view];
        __weak typeof(self) weakSelf = self;
        [LPLoadFailedView showLoadFailedInView:self.view retryHandle:^{
            [weakSelf loadData];
        }];
    }];
}

- (void)loadMoreDataWithContext:(ASBatchContext *)context
{
    if (context) {
        [context beginBatchFetching];
    }
    
    LPHttpRequest *newCommentsRequest = [LPNewsCommentOperation requestNewCommentWithNewsId:_newsId pageIndex:_curIndexPage pageSize:12];
    [newCommentsRequest loadWithSuccessBlock:^(LPHttpRequest *request) {
        LPNewsCommentModel *newestComments = request.responseObject.data;
        if (newestComments.commentIds.count > 0) {
            
            NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:_newestComments.comments];
            [dic addEntriesFromDictionary:newestComments.comments];
            _newestComments.comments  = [dic copy];
            
            NSMutableArray *indexPaths = [NSMutableArray array];
            for (NSInteger row = _newestComments.commentIds.count; row<_newestComments.commentIds.count+newestComments.commentIds.count; ++row) {
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
