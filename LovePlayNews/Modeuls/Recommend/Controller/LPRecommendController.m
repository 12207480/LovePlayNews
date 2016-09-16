//
//  LPRecommendController.m
//  LovePlayNews
//
//  Created by tany on 16/8/26.
//  Copyright © 2016年 tany. All rights reserved.
//

#import "LPRecommendController.h"
#import "LPRecommendOperation.h"
#import "LPRecommendCellNode.h"
#import "LPLoadingView.h"
#import "LPImagePagerCellNode.h"
#import "LPGameNewsController.h"
#import "LPLoadFailedView.h"
#import "LPNewsDetailController.h"

@interface LPRecommendController ()<ASCollectionDataSource, ASCollectionDelegate>

// UI
@property (nonatomic, strong) ASCollectionNode *collectionNode;
@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;

// Data
@property (nonatomic, strong) NSArray *topicDatas;
@property (nonatomic, strong) NSArray *imageInfoDatas;

@end

#define kRecommendPagerHeight 113
#define kRecommendItemWidth (kScreenWidth > 320 ? 98 : 86)
#define kRecommendItemHeight 102
#define kRecommendItemHorEdge (kScreenWidth > 320 ? 16 : 10)
#define kRecommendItemVerEdge 20

static NSString *footerId = @"UICollectionReusableView";

@implementation LPRecommendController

#pragma mark - life cycle

- (instancetype)init
{
    if (self = [super initWithNode:[ASDisplayNode new]]) {
        
        [self addCollectionNode];
    }
    return self;
}

- (void)addCollectionNode
{
    _flowLayout     = [[UICollectionViewFlowLayout alloc] init];
    _collectionNode = [[ASCollectionNode alloc] initWithCollectionViewLayout:_flowLayout];
    _collectionNode.backgroundColor = [UIColor whiteColor];
    _collectionNode.delegate = self;
    _collectionNode.dataSource = self;
    
    [self.node addSubnode:_collectionNode];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"精选";
    self.view.backgroundColor = [UIColor whiteColor];
    [_collectionNode.view registerSupplementaryNodeOfKind:UICollectionElementKindSectionFooter];
    
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
    _collectionNode.frame = self.node.bounds;
}

#pragma mark - load data

- (void)loadData
{
    LPHttpRequest *topicRequest = [LPRecommendOperation requestRecommendTopicList];
    LPHttpRequest *imageInfosRequest = [LPRecommendOperation requestRecommendImageInfos];
    
    TYBatchRequest *batchRequest = [[TYBatchRequest alloc]init];
    [batchRequest addRequestArray:@[imageInfosRequest,topicRequest]];
    
    [LPLoadingView showLoadingInView:self.view];
    [batchRequest loadWithSuccessBlock:^(TYBatchRequest *request) {
        if (request.requestCompleteCount >= 2) {
            LPHttpRequest *imageInfos = request.batchRequstArray[0];
            LPHttpRequest *topic = request.batchRequstArray[1];
            
            _topicDatas = topic.responseObject.data;
            _imageInfoDatas = imageInfos.responseObject.data;
            [_collectionNode reloadData];
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

- (void)gotoGameNewsControllerWithItem:(LPRecommendItem *)item
{
    LPGameNewsController *gameNewsVC = [[LPGameNewsController alloc]init];
    gameNewsVC.newsTopId = item.topicId;
    gameNewsVC.title = item.topicName;
    gameNewsVC.sourceType = item.sourceType;
    [self.navigationController pushViewController:gameNewsVC animated:YES];
}

#pragma mark - ASCollectionDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 1;
        case 1:
            return _topicDatas.count;
        default:
            return 0;
    }
}

- (ASCellNodeBlock)collectionView:(ASCollectionView *)collectionView nodeBlockForItemAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
        {
            NSArray *imageInfos = _imageInfoDatas;
            __typeof (self) __weak weakSelf = self;
            ASCellNode *(^cellNodeBlock)() = ^ASCellNode *() {
                LPImagePagerCellNode *cellNode = [[LPImagePagerCellNode alloc]initWithImageInfos:imageInfos];
                
                [cellNode setDidSelectImageInfoHandle:^(LPTopicImageInfo *imageInfo) {
                    LPNewsDetailController *detail = [[LPNewsDetailController alloc]init];
                    detail.newsId = imageInfo.docid;
                    [weakSelf.navigationController pushViewController:detail animated:YES];
                }];
                return cellNode;
            };
            return cellNodeBlock;
        }
        case 1:
        {
            LPRecommendItem *item = _topicDatas[indexPath.row];
            ASCellNode *(^cellNodeBlock)() = ^ASCellNode *() {
                LPRecommendCellNode *cellNode = [[LPRecommendCellNode alloc]initWithItem:item];
                return cellNode;
            };
            return cellNodeBlock;
        }
        default:
            return nil;
    }
}

- (ASCellNode *)collectionView:(ASCollectionView *)collectionView nodeForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && [kind isEqualToString:UICollectionElementKindSectionFooter]) {
        
        ASCellNode *cellNode = [[ASCellNode alloc]init];
        cellNode.backgroundColor = RGB_255(241, 241, 241);
        cellNode.preferredFrameSize = CGSizeMake(CGRectGetWidth(self.view.frame), 6);
        return cellNode;
    }
    return nil;
}

#pragma mark - ASCollectionDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        LPRecommendItem *item = _topicDatas[indexPath.row];
        [self gotoGameNewsControllerWithItem:item];
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        return CGSizeMake(CGRectGetWidth(self.view.frame), 6);
    }
    return CGSizeZero;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    switch (section) {
        case 0:
            return UIEdgeInsetsMake(15, 0, 15, 0);
        case 1:
            return UIEdgeInsetsMake(kRecommendItemVerEdge, kRecommendItemHorEdge, kRecommendItemVerEdge, kRecommendItemHorEdge);
        default:
            return UIEdgeInsetsZero;
    }
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    switch (section) {
        case 1:
            return 35;
        default:
            return 0;
    }
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    switch (section) {
        case 1:
            return floor((CGRectGetWidth(collectionView.frame) - 3*kRecommendItemWidth - 2*kRecommendItemHorEdge)/2);
        default:
            return 0;
    }
}

- (ASSizeRange)collectionView:(ASCollectionView *)collectionView constrainedSizeForNodeAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
            return ASSizeRangeMake(CGSizeMake(CGRectGetWidth(self.view.frame), kRecommendPagerHeight),CGSizeMake(CGRectGetWidth(self.view.frame), kRecommendPagerHeight));
        case 1:
            return ASSizeRangeMake(CGSizeMake(kRecommendItemWidth, kRecommendItemHeight),CGSizeMake(kRecommendItemWidth, kRecommendItemHeight));
        default:
            return ASSizeRangeMake(CGSizeZero,CGSizeZero);
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
