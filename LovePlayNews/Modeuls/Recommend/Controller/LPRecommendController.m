//
//  LPRecommendController.m
//  LovePlayNews
//
//  Created by tany on 16/8/26.
//  Copyright © 2016年 tany. All rights reserved.
//

#import "LPRecommendController.h"
#import "LPRecommendOperation.h"
#import "LPRecommendItemCell.h"
#import "LPLoadingView.h"

@interface LPRecommendController ()<ASCollectionDataSource, ASCollectionDelegate>

// UI
@property (nonatomic, strong) ASCollectionNode *collectionNode;
@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;

// Data
@property (nonatomic, strong) NSArray *topicDatas;
@property (nonatomic, strong) NSArray *imageInfoDatas;

@end

#define kRecommendItemWidth 98
#define kRecommendItemHeight 102
#define kRecommendItemHorEdge 16
#define kRecommendItemVerEdge 20

@implementation LPRecommendController

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
    
    _flowLayout.minimumInteritemSpacing = (kScreenWidth - 3*kRecommendItemWidth - 2*kRecommendItemHorEdge)/4;
    _flowLayout.minimumLineSpacing = 35;
    _flowLayout.sectionInset = UIEdgeInsetsMake(kRecommendItemVerEdge, kRecommendItemHorEdge, kRecommendItemVerEdge, kRecommendItemHorEdge);
    _flowLayout.itemSize = CGSizeMake(kRecommendItemWidth, kRecommendItemHeight);
    
    _collectionNode.backgroundColor = [UIColor whiteColor];
    _collectionNode.delegate = self;
    _collectionNode.dataSource = self;
    
    [self.node addSubnode:_collectionNode];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self loadData];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    _collectionNode.frame = self.view.bounds;
}

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
    }];
}

#pragma mark - ASCollectionDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _topicDatas.count;
}

- (ASCellNodeBlock)collectionView:(ASCollectionView *)collectionView nodeBlockForItemAtIndexPath:(NSIndexPath *)indexPath
{
    LPRecommendItem *item = _topicDatas[indexPath.row];
    ASCellNode *(^cellNodeBlock)() = ^ASCellNode *() {
        LPRecommendItemCell *cellNode = [[LPRecommendItemCell alloc]initWithItem:item];
        return cellNode;
    };
    return cellNodeBlock;
}

- (ASSizeRange)collectionView:(ASCollectionView *)collectionView constrainedSizeForNodeAtIndexPath:(NSIndexPath *)indexPath
{
    return ASSizeRangeMake(CGSizeMake(kRecommendItemWidth, kRecommendItemHeight),CGSizeMake(kRecommendItemWidth, kRecommendItemHeight));
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
