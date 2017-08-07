//
//  LPDiscuzListController.m
//  LovePlayNews
//
//  Created by tany on 16/9/7.
//  Copyright © 2016年 tany. All rights reserved.
//

#import "LPDiscuzListController.h"
#import "LPGameZoneOperation.h"
#import "LPLoadingView.h"
#import "LPLoadFailedView.h"
#import "LPDiscuzCellNode.h"
#import "LPTopDiscuzCellNode.h"
#import "LPDiscuzHeaderView.h"
#import "MXParallaxHeader.h"
#import <YYWebImage.h>
#import "LPNavigationBarView.h"
#import "LPDiscuzDetailController.h"

@interface LPDiscuzListController ()<ASTableDelegate, ASTableDataSource>

// UI
@property (nonatomic, weak) LPNavigationBarView *navBar;
@property (nonatomic, strong) ASTableNode *tableNode;
@property (nonatomic, weak) LPDiscuzHeaderView *headerView;

// Data
@property (nonatomic, strong) NSArray *topDiscuzs;
@property (nonatomic, strong) NSArray *discuzs;

@property (nonatomic, assign) NSInteger curIndexPage;
@property (nonatomic, assign) BOOL haveMore;

@end

#define kHeaderViewHeight 120

@implementation LPDiscuzListController

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
    _tableNode.backgroundColor = [UIColor whiteColor];
    _tableNode.delegate = self;
    _tableNode.dataSource = self;
    [self.node addSubnode:_tableNode];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view layoutIfNeeded];
    
    [self addNavBarView];
    
    [self configureTableView];
    
    [self addTableHeaderView];
    
    [self loadData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    _tableNode.frame = self.node.bounds;
    _navBar.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), kNavBarHeight);
}

- (void)addNavBarView
{
    LPNavigationBarView *navBar = [LPNavigationBarView loadInstanceFromNib];
    [self.view addSubview:navBar];
    _navBar = navBar;
    _navBar.backgroundAlpha = 0;
}

- (void)configureTableView
{
    _tableNode.view.tableFooterView = [[UIView alloc]init];
    _tableNode.view.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)addTableHeaderView
{
    LPDiscuzHeaderView *headerView = [LPDiscuzHeaderView loadInstanceFromNib];
    _tableNode.view.parallaxHeader.view = headerView;
    _tableNode.view.parallaxHeader.height = kHeaderViewHeight;
    _tableNode.view.parallaxHeader.mode = MXParallaxHeaderModeFill;
    _tableNode.view.parallaxHeader.contentView.layer.zPosition = 1;
    _headerView = headerView;
}

#pragma mark - load data

- (void)loadData
{
    _curIndexPage = 1;
    _haveMore = YES;
    [LPLoadingView showLoadingInView:self.view];
    
    LPHttpRequest *discuzImageRequest = [LPGameZoneOperation requestDiscuzImageWithFid:_fid];
    LPHttpRequest *discuzListRequest = [LPGameZoneOperation requestDiscuzListWithFid:_fid Index:_curIndexPage];
    
    TYBatchRequest *batchRequest = [[TYBatchRequest alloc]init];
    [batchRequest addRequestArray:@[discuzImageRequest,discuzListRequest]];
    
    [batchRequest loadWithSuccessBlock:^(TYBatchRequest *request) {
        if (request.requestCompleteCount > 1) {
            LPHttpRequest *disImageRequest = request.batchRequstArray[0];
            LPHttpRequest *disListRequest = request.batchRequstArray[1];
            
            LPZoneDiscuzItem *headerItem = disImageRequest.responseObject.data;
            LPDiscuzListModel *discuzModel = disListRequest.responseObject.data;
            [self dealWithDiscuzHeaderViewWithItem:headerItem forum:discuzModel.forum];
            [self dealWithDiscuzList:discuzModel.forum_threadlist];
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
    [context beginBatchFetching];
    LPHttpRequest *discuzRequest = [LPGameZoneOperation requestDiscuzListWithFid:_fid Index:_curIndexPage];
    [discuzRequest loadWithSuccessBlock:^(LPHttpRequest *request) {
        LPDiscuzListModel *discuzModel = request.responseObject.data;
        NSArray *threadList = discuzModel.forum_threadlist;
        if (threadList.count > 0) {
            NSMutableArray *indexPaths = [NSMutableArray array];
            for (NSInteger row = _discuzs.count; row<_discuzs.count+threadList.count; ++row) {
                [indexPaths addObject:[NSIndexPath indexPathForRow:row inSection:1]];
            }
            _discuzs = [_discuzs arrayByAddingObjectsFromArray:threadList];
            [_tableNode.view insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
            _curIndexPage++;
            _haveMore = YES;
        }else {
            _haveMore = NO;
        }
        [context completeBatchFetching:YES];
    } failureBlock:^(id<TYRequestProtocol> request, NSError *error) {
        [context completeBatchFetching:YES];
    }];
}

- (void)dealWithDiscuzHeaderViewWithItem:(LPZoneDiscuzItem *)headerItem forum:(LPDiscuzforum *)forum
{
    [_headerView.imageView setYy_imageURL:[NSURL URLWithString:headerItem.bannerUrl]];
    _headerView.titleLabel.text = headerItem.modelName;
    _headerView.descripLabel.text = [NSString stringWithFormat:@"今日%@    主题%@",forum.todayposts,forum.posts];
}

- (void)dealWithDiscuzList:(NSArray *)discuzList
{
    NSMutableArray *topDiscuz = [NSMutableArray array];
    NSMutableArray *discuz = [NSMutableArray array];
    
    for (LPForumThread *forum in discuzList) {
        if (forum.displayorder == 1) {
            [topDiscuz addObject:forum];
        }else {
            [discuz addObject:forum];
        }
    }
    _discuzs = [discuz copy];
    _topDiscuzs = [topDiscuz copy];
}

#pragma mark - ASTableDataSource

- (BOOL)shouldBatchFetchForTableView:(ASTableView *)tableView
{
    return _discuzs.count && _haveMore;
}

- (void)tableView:(ASTableView *)tableView willBeginBatchFetchWithContext:(ASBatchContext *)context
{
    [self loadMoreDataWithContext:context];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return _topDiscuzs.count;
        case 1:
            return _discuzs.count;
        default:
            return 0;
    }
}

- (ASCellNodeBlock)tableView:(ASTableView *)tableView nodeBlockForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        LPForumThread *item = _topDiscuzs[indexPath.row];
        ASCellNode *(^cellNodeBlock)() = ^ASCellNode *() {
            LPTopDiscuzCellNode *cellNode = [[LPTopDiscuzCellNode alloc] initWithItem:item];
            return cellNode;
        };
        return cellNodeBlock;
    }else if (indexPath.section == 1){
        LPForumThread *item = _discuzs[indexPath.row];
        ASCellNode *(^cellNodeBlock)() = ^ASCellNode *() {
            LPDiscuzCellNode *cellNode = [[LPDiscuzCellNode alloc] initWithItem:item];
            return cellNode;
        };
        return cellNodeBlock;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    LPForumThread *item = indexPath.section == 0 ? _topDiscuzs[indexPath.row] : _discuzs[indexPath.row];
    LPDiscuzDetailController *discuzDetailVC = [[LPDiscuzDetailController alloc]init];
    discuzDetailVC.tid = item.tid;
    [self.navigationController pushViewController:discuzDetailVC animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat headerViewHeight = kHeaderViewHeight;
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY <= 0) {
        _navBar.backgroundAlpha = 0;
    }else if (offsetY >= headerViewHeight) {
        _navBar.backgroundAlpha = 1.0;
    }else {
        _navBar.backgroundAlpha = offsetY/headerViewHeight;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
    DLog(@"LPDiscuzListController dealloc");
}

@end
