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
#import "LPNewsRequestOperation.h"
#import "MBProgressHUD+MJ.h"
#import "MXParallaxHeader.h"
#import "LPNewsTitleHeaderView.h"
#import "UIView+Nib.h"
#import "LPNewsTitleSectionView.h"
#import "LPNewsCommentCellNode.h"

@interface LPNewsDetailController ()<ASTableDelegate, ASTableDataSource>

// UI
@property (nonatomic, strong) ASTableNode *tableNode;
@property (nonatomic, strong) LPNewsTitleHeaderView *headerView;

// Data
@property (nonatomic, strong) LPNewsDetailModel *newsDetail;
@property (nonatomic, strong) NSArray *hotComments;
@property (nonatomic, assign) BOOL webViewFinishLoad;

@end

static NSString *headerId = @"LPNewsTitleSectionView";

@implementation LPNewsDetailController

- (instancetype)init
{
    _tableNode = [[ASTableNode alloc] initWithStyle:UITableViewStyleGrouped];
    if (self = [super initWithNode:_tableNode]) {
        _tableNode.delegate = self;
        _tableNode.dataSource = self;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self configureController];
    
    [self configureTableView];
    
    [self addHeaderView];
    
    [self loadData];
}

- (void)configureController
{
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.extendedLayoutIncludesOpaqueBars = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = RGB_255(247, 247, 247);
}

- (void)configureTableView
{
    _tableNode.view.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableNode.view.tableFooterView = [[UIView alloc]init];
    
    [_tableNode.view registerClass:[LPNewsTitleSectionView class] forHeaderFooterViewReuseIdentifier:headerId];
}

- (void)addHeaderView
{
    LPNewsTitleHeaderView *headerView = [LPNewsTitleHeaderView loadInstanceFromNib];
    [headerView.goBackBtn addTarget:self action:@selector(goBackAction) forControlEvents:UIControlEventTouchUpInside];
    _tableNode.view.parallaxHeader.view = headerView;
    _tableNode.view.parallaxHeader.height = 165;
    _tableNode.view.parallaxHeader.minimumHeight = 64;
    _tableNode.view.parallaxHeader.mode = MXParallaxHeaderModeFill;
    _tableNode.view.parallaxHeader.contentView.layer.zPosition = 1;
    _headerView = headerView;
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
    [MBProgressHUD showMessage:@"加载中..." toView:self.view];
    LPHttpRequest *newsListRequest = [LPNewsRequestOperation requestNewsDetailWithNewsId:_newsId];
    [newsListRequest loadWithSuccessBlock:^(LPHttpRequest *request) {
         LPNewsDetailModel *newsDetail = request.responseObject.data;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [self replaceDetailImageWithArticle:newsDetail.article];
            NSArray *hotComments = [self hotCommentsWithTie:newsDetail.tie];
            dispatch_async(dispatch_get_main_queue(), ^{
                _newsDetail = newsDetail;
                _hotComments = hotComments;
                [self configureHeaderView];
                [_tableNode.view reloadData];
                [MBProgressHUD hideHUDForView:self.view];
            });
        });
    } failureBlock:^(LPHttpRequest *request, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view];
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

- (NSArray *)hotCommentsWithTie:(LPNewsCommonModel *)tie
{
    NSArray *hotComments = [[tie.comments allValues] sortedArrayUsingComparator:^NSComparisonResult(LPNewsCommonItem *obj1, LPNewsCommonItem *obj2) {
        if (obj1.vote < obj2.vote) {
            return NSOrderedDescending;
        }else if (obj1.vote > obj2.vote) {
            return NSOrderedAscending;
        }else {
            return NSOrderedSame;
        }
    }];
    
    for (LPNewsCommonItem *item in hotComments) {
        item.content = [item.content stringByReplacingOccurrencesOfString:@"<br>" withString:@"\n"];
    }
    
    return hotComments;
}

#pragma mark - action

- (void)goBackAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - ASTableDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _hotComments.count > 0 ? 2:1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return _newsDetail.article.digest.length > 0 ? 2 : 1;
        case 1:
            return _hotComments.count;
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
        LPNewsCommonItem *item = _hotComments[indexPath.row];
        ASCellNode *(^commentCellNodeBlock)() = ^ASCellNode *() {
            LPNewsCommentCellNode *cellNode = [[LPNewsCommentCellNode alloc] initWithCommentItem:item];
            return cellNode;
        };
        return commentCellNodeBlock;
    }else if (indexPath.section == 2) {
        // section 2
        
    }
    
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(section > 0 && _hotComments.count > 0 && _webViewFinishLoad) {
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

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if ( section > 0 && _hotComments.count > 0 && _webViewFinishLoad) {
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

- (void)dealloc{
    _tableNode.delegate = nil;
    _tableNode.dataSource = nil;
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
