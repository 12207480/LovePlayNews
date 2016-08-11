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

@interface LPNewsDetailController ()<ASTableDelegate, ASTableDataSource>

// UI
@property (nonatomic, strong) ASTableNode *tableNode;
@property (nonatomic, strong) LPNewsTitleHeaderView *headerView;

// Data
@property (nonatomic, strong) LPNewsDetailModel *newsDetail;

@end

@implementation LPNewsDetailController

- (instancetype)init
{
    _tableNode = [[ASTableNode alloc] init];
    if (self = [super initWithNode:_tableNode]) {
        _tableNode.delegate = self;
        _tableNode.dataSource = self;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.extendedLayoutIncludesOpaqueBars = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self configureTableView];
    
    [self addHeaderView];
    
    [self loadData];
}

- (void)configureTableView
{
    _tableNode.view.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableNode.view.tableFooterView = [[UIView alloc]init];
}

- (void)addHeaderView
{
    LPNewsTitleHeaderView *headerView = [LPNewsTitleHeaderView loadInstanceFromNib];
    [headerView.goBackBtn addTarget:self action:@selector(goBackAction) forControlEvents:UIControlEventTouchUpInside];
    _tableNode.view.parallaxHeader.view = headerView;
    _tableNode.view.parallaxHeader.height = 165;
    _tableNode.view.parallaxHeader.minimumHeight = 64;
    _tableNode.view.parallaxHeader.mode = MXParallaxHeaderModeFill;
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

- (void)loadData
{
    LPHttpRequest *newsListRequest = [LPNewsRequestOperation requestNewsDetailWithNewsId:_newsId];
    [MBProgressHUD showMessage:@"加载中..." toView:self.view];
    [newsListRequest loadWithSuccessBlock:^(LPHttpRequest *request) {
        _newsDetail = request.responseObject.data;
        [self configureHeaderView];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [self replaceDetailImageWithArticle:_newsDetail.article];
            dispatch_async(dispatch_get_main_queue(), ^{
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
        NSString *replaceString = [NSString stringWithFormat:@"<img src=\"%@\"/>",image.src];
        [body replaceOccurrencesOfString:image.ref withString:replaceString options:NSCaseInsensitiveSearch range:NSMakeRange(0, body.length)];
    }
    _newsDetail.article.body = [body copy];
}

- (void)goBackAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - ASTableDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _newsDetail ? (_newsDetail.article.digest.length > 0 ? 2 : 1 ) : 0;
}

- (ASCellNodeBlock)tableView:(ASTableView *)tableView nodeBlockForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *body = _newsDetail.article.body;
    ASCellNode *(^webCellNodeBlock)() = ^ASCellNode *() {
        LPWebCellNode *cellNode = [[LPWebCellNode alloc] initWithHtmlBody:body];
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
    
    return nil;
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
