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

@interface LPDiscuzDetailController ()<UITableViewDataSource, UITableViewDelegate>

// UI
@property (nonatomic, weak) LPNavigationBarView *navBar;
@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, weak) LPDiscuzTitleView *headerView;

// Data
@property (nonatomic, strong) LPDiscuzThread *thread;
@property (nonatomic, strong) NSArray *discuzPosts;

@property (nonatomic,assign) CGFloat webViewHeight;

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
    
    [self addNavBarView];
    
    [self addTableView];
    
    [self addTableHeaderView];
    
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
    _tableView.parallaxHeader.mode = MXParallaxHeaderModeBottomFill;
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

#pragma mark - load Data

- (void)loadData
{
    [LPLoadingView showLoadingInView:self.view];
    LPHttpRequest *discuzDetailRequest = [LPGameZoneOperation requestDiscuzDetailWithTid:_tid Index:1];
    
    [discuzDetailRequest loadWithSuccessBlock:^(LPHttpRequest *request) {
        LPDiscuzDetailModel *discuzDetailModel = request.responseObject.data;
        _thread = discuzDetailModel.thread;
        _discuzPosts = discuzDetailModel.postlist;
        
        CGFloat textHeight = [_thread.subject boundingSizeWithFont:_headerView.titleLabel.font constrainedToSize:CGSizeMake(CGRectGetWidth(self.view.frame), 300)].height;
        _headerView.titleLabel.text = _thread.subject;
        _tableView.parallaxHeader.height = ceil(textHeight) + 80;
        [_tableView reloadData];
    } failureBlock:^(id<TYRequestProtocol> request, NSError *error) {
        [LPLoadingView hideLoadingForView:self.view];
        __weak typeof(self) weakSelf = self;
        [LPLoadFailedView showLoadFailedInView:self.view retryHandle:^{
            [weakSelf loadData];
        }];
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
    return 60;
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
