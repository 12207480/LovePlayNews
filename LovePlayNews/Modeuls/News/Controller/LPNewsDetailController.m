//
//  LPNewsDetailController.m
//  LovePlayNews
//
//  Created by tanyang on 16/8/6.
//  Copyright © 2016年 tany. All rights reserved.
//

#import "LPNewsDetailController.h"
#import "LPWebCellNode.h"
#import "LPNewsBreifCellNode.h"
#import "LPGameNewsOperation.h"
#import "MXParallaxHeader.h"
#import "LPNewsTitleHeaderView.h"
#import "LPNewsCommentFooterView.h"
#import "LPNewsTitleSectionView.h"
#import "LPNewsCommentCellNode.h"
#import "LPNewsFavorCellNode.h"
#import "LPNewsCommentController.h"
#import "LPLoadingView.h"
#import "LPLoadFailedView.h"
#import "LPNavigationBarView.h"

@interface LPNewsDetailController ()<ASTableDelegate, ASTableDataSource>

// UI
@property (nonatomic, weak) LPNavigationBarView *navBar;
@property (nonatomic, strong) ASTableNode *tableNode;
@property (nonatomic, strong) LPNewsTitleHeaderView *headerView;

// Data
@property (nonatomic, strong) LPNewsDetailModel *newsDetail;
@property (nonatomic, strong) NSArray *favors;
@property (nonatomic, assign) BOOL webViewFinishLoad;

@end

static NSString *headerId = @"LPNewsTitleSectionView";
static NSString *footerId = @"LPNewsCommentFooterView";

#define kHeaderViewHeight 164

@implementation LPNewsDetailController

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
    _tableNode = [[ASTableNode alloc] initWithStyle:UITableViewStyleGrouped];
    _tableNode.backgroundColor = RGB_255(247, 247, 247);
    _tableNode.delegate = self;
    _tableNode.dataSource = self;
    [self.node addSubnode:_tableNode];
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

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view layoutIfNeeded];
    
    [self addNavBarView];
    
    [self configureTableView];
    
    [self addHeaderView];
    
    [self loadData];
}

- (void)addNavBarView
{
    LPNavigationBarView *navBar = [LPNavigationBarView loadInstanceFromNib];
    [self.view addSubview:navBar];
    _navBar = navBar;
    _navBar.backgroundAlpha = 0;
}

- (void)addHeaderView
{
    LPNewsTitleHeaderView *headerView = [LPNewsTitleHeaderView loadInstanceFromNib];
    _tableNode.view.parallaxHeader.view = headerView;
    _tableNode.view.parallaxHeader.height = kHeaderViewHeight;
    _tableNode.view.parallaxHeader.mode = MXParallaxHeaderModeFill;
    _headerView = headerView;
}

#pragma mark - configure

- (void)configureTableView
{
    _tableNode.view.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableNode.view.tableFooterView = [[UIView alloc]init];
    
    [_tableNode.view registerClass:[LPNewsTitleSectionView class] forHeaderFooterViewReuseIdentifier:headerId];
    [_tableNode.view registerClass:[LPNewsCommentFooterView class] forHeaderFooterViewReuseIdentifier:footerId];
}

- (void)configureHeaderView
{
    NSString *title = _newsDetail.article.title;
    NSMutableAttributedString * attributedString = [[NSMutableAttributedString alloc] initWithString:title];
    [attributedString addAttributes:@{ NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue-Bold" size:24.0f] ,NSForegroundColorAttributeName: [UIColor whiteColor]} range:NSMakeRange(0, [title length])];
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:12];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [title length])];
    _headerView.titleLabel.attributedText = attributedString;
    _headerView.timeLabel.text = [NSString stringWithFormat:@"%@  %@",_newsDetail.article.source,_newsDetail.article.ptime];
}

#pragma mark - load data

- (void)loadData
{
    [LPLoadingView showLoadingInView:self.view];
    LPHttpRequest *newsListRequest = [LPGameNewsOperation requestNewsDetailWithNewsId:_newsId];
    newsListRequest.asynCompleteQueue = YES;
    [newsListRequest loadWithSuccessBlock:^(LPHttpRequest *request) {
         LPNewsDetailModel *newsDetail = request.responseObject.data;
        [self replaceDetailImageWithArticle:newsDetail.article];
        dispatch_async(dispatch_get_main_queue(), ^{
            _newsDetail = newsDetail;
            _favors = newsDetail.article.relative_sys;
            [self configureHeaderView];
            [_tableNode.view reloadData];
        });
    } failureBlock:^(LPHttpRequest *request, NSError *error) {
         dispatch_async(dispatch_get_main_queue(), ^{
             [LPLoadingView hideLoadingForView:self.view];
             __weak typeof(self) weakSelf = self;
             [LPLoadFailedView showLoadFailedInView:self.view retryHandle:^{
                 [weakSelf loadData];
             }];
        });
    }];
}

- (void)replaceDetailImageWithArticle:(LPNewsArticleModel *)article
{
    NSMutableString *body = [NSMutableString stringWithString:article.body];
    for (LPNewsDetailImgeInfo *image in article.img) {
        NSString *replaceString = [NSString stringWithFormat:@"<img src=\"%@\" alt=\"%@\" />",image.src,image.alt?image.alt:@""];
        [body replaceOccurrencesOfString:image.ref withString:replaceString options:NSCaseInsensitiveSearch range:NSMakeRange(0, body.length)];
    }
    article.body = [body copy];
}

#pragma mark - action

- (void)goBackAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)gotoCommentViewController
{
    LPNewsCommentController *commentVC = [[LPNewsCommentController alloc]init];
    commentVC.newsId = self.newsId;
    [self.navigationController pushViewController:commentVC animated:YES];
}

#pragma mark - ASTableDataSource

- (BOOL)shouldBatchFetchForTableView:(ASTableView *)tableView
{
    return NO;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger numberOfSections = 1;
    if (_newsDetail.tie.commentIds.count > 0) {
        ++numberOfSections;
    }
    if (_favors.count > 0) {
        ++numberOfSections;
    }
    return numberOfSections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return _newsDetail.article.digest.length > 0 ? 2 : 1;
        case 1:
            return _newsDetail.tie.commentIds.count;
        case 2:
            return _favors.count;
        default:
            return 0;
    }
}

- (ASCellNodeBlock)tableView:(ASTableView *)tableView nodeBlockForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        // section 0
        NSString *body = _newsDetail.article.body;
        __typeof (self) __weak weakSelf = self;
        ASCellNode *(^webCellNodeBlock)() = ^ASCellNode *() {
            LPWebCellNode *cellNode = [[LPWebCellNode alloc] initWithHtmlBody:body];
            [cellNode setWebViewDidFinishLoad:^{
                weakSelf.webViewFinishLoad = YES;
                [LPLoadingView hideLoadingForView:weakSelf.view];
            }];
            return cellNode;
        };
        NSString *brief = _newsDetail.article.digest;
        ASCellNode *(^briefCellNodeBlock)() = ^ASCellNode *() {
            LPNewsBreifCellNode *cellNode = [[LPNewsBreifCellNode alloc] initWithBreif:brief];
            return cellNode;
        };
        
        if (_newsDetail.article.digest.length <= 0 ) {
            return webCellNodeBlock;
        }
        
        switch (indexPath.row) {
            case 0:
                return briefCellNodeBlock;
            case 1:
                return webCellNodeBlock;
            default:
                break;
        }
    }else if (indexPath.section == 1){
        // section 1
        NSArray *floors = _newsDetail.tie.commentIds[indexPath.row];
        ASCellNode *(^commentCellNodeBlock)() = ^ASCellNode *() {
            LPNewsCommentCellNode *cellNode = [[LPNewsCommentCellNode alloc] initWithCommentItems:_newsDetail.tie.comments floors:floors];
            return cellNode;
        };
        return commentCellNodeBlock;
    }else if (indexPath.section == 2) {
        // section 2
        LPNewsFavorInfo *favorInfo = _favors[indexPath.row];
        ASCellNode *(^favorCellNodeBlock)() = ^ASCellNode *() {
            LPNewsFavorCellNode *cellNode = [[LPNewsFavorCellNode alloc] initWithFavors:favorInfo];
            return cellNode;
        };
        return favorCellNodeBlock;
    }
    
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(section > 0 && _newsDetail.tie.commentIds.count > 0 && _webViewFinishLoad) {
        LPNewsTitleSectionView *sectionView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:headerId];

        switch (section) {
            case 1:
                sectionView.title = @"热门跟帖";
                break;
            case 2:
                sectionView.title = @"猜你喜欢";
                break;
            default:
                break;
        }
        
        return sectionView;
    }
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 1 && _newsDetail.tie.commentIds.count > 0 && _webViewFinishLoad) {
        LPNewsCommentFooterView *footerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:footerId];
        footerView.title = @"查看更多跟帖";
        __typeof (self) __weak weakSelf = self;
        [footerView setClickedHandle:^{
            [weakSelf gotoCommentViewController];
        }];
        return footerView;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if ( section > 0 && _newsDetail.tie.commentIds.count > 0 && _webViewFinishLoad) {
        return 28;
    }
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if ( section == 1 && _newsDetail.tie.commentIds.count > 0 && _webViewFinishLoad) {
        return 40;
    }
    return 0.1;
}

#pragma mark - ASTableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 1:
        {
            [self gotoCommentViewController];
        }
            break;
        case 2:
        {
            LPNewsFavorInfo *favorInfo = _favors[indexPath.row];
            LPNewsDetailController *detail = [[LPNewsDetailController alloc]init];
            detail.newsId = favorInfo.docID;
            [self.navigationController pushViewController:detail animated:YES];
        }
            break;
        default:
            break;
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offsetY = scrollView.contentOffset.y;
    CGFloat headerViewHeight = kHeaderViewHeight;
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
