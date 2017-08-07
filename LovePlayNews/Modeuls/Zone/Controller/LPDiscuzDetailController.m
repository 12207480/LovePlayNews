//
//  LPDiscuzDetailController.m
//  LovePlayNews
//
//  Created by tanyang on 16/9/8.
//  Copyright © 2016年 tany. All rights reserved.
//

#import "LPDiscuzDetailController.h"
#import "LPGameZoneOperation.h"
#import "LPNavigationBarView.h"
#import "LPDiscuzWebViewCell.h"
#import "LPLoadingView.h"
#import "LPLoadFailedView.h"
#import "LPDiscuzTitleView.h"
#import "MXParallaxHeader.h"
#import "NSString+Size.h"
#import <YYWebImage.h>
#import "LPDiscuzPostCell.h"
#import "LPPostTextParser.h"
#import "LPRefreshAutoFooter.h"

@interface LPDiscuzDetailController ()<UITableViewDataSource, UITableViewDelegate>

// UI
@property (nonatomic, weak) LPNavigationBarView *navBar;
@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, weak) LPDiscuzTitleView *headerView;

// Data
@property (nonatomic, strong) LPDiscuzThread *thread;
@property (nonatomic, strong) NSArray *discuzPosts;

@property (nonatomic,assign) CGFloat webViewHeight;
@property (nonatomic, assign) NSInteger curIndexPage;
@property (nonatomic, assign) NSInteger pageSize;
@property (nonatomic, assign) BOOL haveMore;

@end

static NSString *webViewCellId = @"LPDiscuzWebViewCell";
static NSString *discuzPostCelllId = @"LPDiscuzPostCell";
#define kHeaderViewHeight 150

@implementation LPDiscuzDetailController

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self addNavBarView];
    
    [self addTableView];
    
    [self addTableHeaderView];
    
    [self addFooterRefresh];
    
    [self registerCells];
    
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
    _navBar.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), kNavBarHeight);
    _tableView.frame = self.view.bounds;
}


- (void)addNavBarView
{
    LPNavigationBarView *navBar = [LPNavigationBarView loadInstanceFromNib];
    [self.view addSubview:navBar];
    _navBar = navBar;
    _navBar.backgroundAlpha = 0;
}

- (void)addTableView
{
    UITableView *tableView = [[UITableView alloc]init];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.tableFooterView = [[UIView alloc] init];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view insertSubview:tableView belowSubview:_navBar];
    _tableView = tableView;
}

- (void)addTableHeaderView
{
    LPDiscuzTitleView *headerView = [LPDiscuzTitleView loadInstanceFromNib];
    _tableView.parallaxHeader.view = headerView;
    _tableView.parallaxHeader.height = kHeaderViewHeight;
    _tableView.parallaxHeader.mode = MXParallaxHeaderModeFill;
    _tableView.parallaxHeader.contentView.layer.zPosition = 1;
    _headerView = headerView;
}

- (void)registerCells
{
    UINib *nib = [UINib nibWithNibName:webViewCellId bundle:nil];
    [_tableView registerNib:nib forCellReuseIdentifier:webViewCellId];
    nib = [UINib nibWithNibName:discuzPostCelllId bundle:nil];
    [_tableView registerNib:nib forCellReuseIdentifier:discuzPostCelllId];
}

- (void)addFooterRefresh
{
    LPRefreshAutoFooter *footer = [LPRefreshAutoFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    _tableView.ty_refreshFooter = footer;
}

#pragma mark - load Data

- (void)loadData
{
    _curIndexPage = 1;
    _pageSize = 15;
    _haveMore = YES;
    [LPLoadingView showLoadingInView:self.view];

    LPHttpRequest *discuzDetailRequest = [LPGameZoneOperation requestDiscuzDetailWithTid:_tid index:_curIndexPage pageSize:_pageSize];
    discuzDetailRequest.asynCompleteQueue = YES;
    [discuzDetailRequest loadWithSuccessBlock:^(LPHttpRequest *request) {
        LPDiscuzDetailModel *discuzDetailModel = request.responseObject.data;
        _thread = discuzDetailModel.thread;
        NSArray *discuzPosts = discuzDetailModel.postlist;
        [self dividePostTextWithPosts:discuzPosts];
        [self parserTextContainerWithPosts:discuzPosts];
        CGFloat textHeight = [_thread.subject boundingSizeWithFont:_headerView.titleLabel.font constrainedToSize:CGSizeMake(CGRectGetWidth(self.view.frame), 105)].height;
        dispatch_async(dispatch_get_main_queue(), ^{
            _discuzPosts = discuzPosts;
            _headerView.titleLabel.text = _thread.subject;
            _tableView.parallaxHeader.height = ceil(textHeight) + 80;
            [_tableView reloadData];
            _curIndexPage++;
            _haveMore = YES;
        });
    } failureBlock:^(id<TYRequestProtocol> request, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [LPLoadingView hideLoadingForView:self.view];
            __weak typeof(self) weakSelf = self;
            [LPLoadFailedView showLoadFailedInView:self.view retryHandle:^{
                [weakSelf loadData];
            }];
        });
    }];
}

- (void)loadMoreData
{
    LPHttpRequest *discuzDetailRequest = [LPGameZoneOperation requestDiscuzDetailWithTid:_tid index:_curIndexPage pageSize:_pageSize];
    discuzDetailRequest.asynCompleteQueue = YES;
    
    [discuzDetailRequest loadWithSuccessBlock:^(LPHttpRequest *request) {
        LPDiscuzDetailModel *discuzDetailModel = request.responseObject.data;
        NSArray *discuzPosts = discuzDetailModel.postlist;
        [self dividePostTextWithPosts:discuzPosts];
        [self parserTextContainerWithPosts:discuzPosts];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (discuzPosts.count > 0) {
                NSMutableArray *indexPaths = [NSMutableArray array];
                for (NSInteger row = _discuzPosts.count; row<_discuzPosts.count+discuzPosts.count; ++row) {
                    [indexPaths addObject:[NSIndexPath indexPathForRow:row inSection:0]];
                }
                _discuzPosts = [_discuzPosts arrayByAddingObjectsFromArray:discuzPosts];
                [_tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
                //[_tableView reloadData];
                _curIndexPage++;
            }
            
            if (discuzPosts.count < _pageSize) {
                _haveMore = NO;
                [_tableView.ty_refreshFooter endRefreshingWithNoMoreData];
            }else {
                _haveMore = YES;
                [_tableView.ty_refreshFooter endRefreshing];
            }
        });
    } failureBlock:^(id<TYRequestProtocol> request, NSError *error) {
        [_tableView.ty_refreshFooter endRefreshing];
    }];
}

- (void)dividePostTextWithPosts:(NSArray *)posts
{
    [posts enumerateObjectsUsingBlock:^(LPDiscuzPost *post, NSUInteger idx, BOOL * stop) {
        if (idx > 0) {
            NSRange rangeStart = [post.message rangeOfString:@"<div"];
            NSRange rangeEnd = [post.message rangeOfString:@"</div>"];
            if (rangeStart.length > 0 && rangeEnd.length > 0 && rangeStart.location < rangeEnd.location) {
                post.replyText = [post.message substringWithRange:NSMakeRange(rangeStart.location, rangeEnd.location+rangeEnd.length-rangeStart.location)];
                post.message = [post.message stringByReplacingOccurrencesOfString:post.replyText withString:@""];
            }
        }
    }];
}

- (void)parserTextContainerWithPosts:(NSArray *)posts
{
    [posts enumerateObjectsUsingBlock:^(LPDiscuzPost *post, NSUInteger idx, BOOL * stop) {
        if (idx > 0) {
            NSString *text = [LPPostTextParser replaceXMLLabelWithText:post.message];
            post.textContainer = [LPPostTextParser parserPostText:text];
        }
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _discuzPosts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LPDiscuzPost *post = _discuzPosts[indexPath.row];
    if (indexPath.row == 0) {
        LPDiscuzWebViewCell *cell = [tableView dequeueReusableCellWithIdentifier:webViewCellId forIndexPath:indexPath];
        if (post.message != cell.htmlBody && _webViewHeight <= 0) {
            [cell.iconView setYy_imageURL:[NSURL URLWithString:@"http://uc.bbs.d.163.com/images/noavatar_middle.gif"]];
            cell.nameLabel.text = post.author;
            cell.timeLabel.text = [post.dateline stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@""];
            cell.htmlBody = post.message;
            [cell loadWebHtml];
            __typeof (self) __weak weakSelf = self;
            [cell setWebViewDidFinishLoad:^(CGFloat webViewHeight){
                weakSelf.webViewHeight = webViewHeight;
                [weakSelf.tableView reloadData];
                [LPLoadingView hideLoadingForView:self.view];
            }];
        }
        return cell;
    }else {
        LPDiscuzPostCell *cell = [tableView dequeueReusableCellWithIdentifier:discuzPostCelllId forIndexPath:indexPath];
        [cell setPost:post floor:indexPath.row+1];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return _webViewHeight+kWebViewTopEdge;
    }
    LPDiscuzPost *post = _discuzPosts[indexPath.row];
    return kDiscuzPostCellEdge + post.textContainer.textHeight;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offsetY = scrollView.contentOffset.y;
    CGFloat headerViewHeight = _tableView.parallaxHeader.height;
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

@end
