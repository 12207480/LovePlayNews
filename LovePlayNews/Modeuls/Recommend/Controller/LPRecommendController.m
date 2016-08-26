//
//  LPRecommendController.m
//  LovePlayNews
//
//  Created by tany on 16/8/26.
//  Copyright © 2016年 tany. All rights reserved.
//

#import "LPRecommendController.h"
#import "LPRecommendOperation.h"

@interface LPRecommendController ()<ASCollectionDataSource, ASCollectionDelegate>

// UI
@property (nonatomic, strong) ASCollectionNode *collectionNode;
@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;

// Data
@property (nonatomic, strong) NSArray *topicDatas;
@property (nonatomic, strong) NSArray *imageInfoDatas;

@end

@implementation LPRecommendController

- (instancetype)init
{
    _flowLayout     = [[UICollectionViewFlowLayout alloc] init];
    _collectionNode = [[ASCollectionNode alloc] initWithCollectionViewLayout:_flowLayout];
    
    self = [super initWithNode:_collectionNode];
    if (self) {
        _collectionNode.backgroundColor = [UIColor whiteColor];
//        _collectionNode.delegate = self;
//        _collectionNode.dataSource = self;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self loadData];
}

- (void)loadData
{
    LPHttpRequest *topicRequest = [LPRecommendOperation requestRecommendTopicList];
    LPHttpRequest *imageInfosRequest = [LPRecommendOperation requestRecommendImageInfos];
    
    TYBatchRequest *batchRequest = [[TYBatchRequest alloc]init];
    [batchRequest addRequestArray:@[imageInfosRequest,topicRequest]];
    
    [batchRequest loadWithSuccessBlock:^(TYBatchRequest *request) {
        if (request.requestCompleteCount >= 2) {
            
        }
        
    } failureBlock:^(TYBatchRequest *request, NSError *error) {
        
    }];
}

#pragma mark - ASCollectionDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
