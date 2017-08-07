//
//  LPZoneDiscuzController.m
//  LovePlayNews
//
//  Created by tany on 16/9/5.
//  Copyright © 2016年 tany. All rights reserved.
//

#import "LPZoneDiscuzController.h"
#import "LPGameZoneOperation.h"
#import "LPLoadingView.h"
#import "LPLoadFailedView.h"
#import "LPZoneDiscuzCellNode.h"
#import "LPDiscuzHeaderNode.h"
#import "LPDiscuzListController.h"

@interface LPZoneDiscuzController ()<ASCollectionDataSource, ASCollectionDelegate>

// UI
@property (nonatomic, strong) ASCollectionNode *collectionNode;
@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;

// Data
@property (nonatomic, strong) NSArray *discuzList;

@end

@implementation LPZoneDiscuzController

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
    
    [self configureCollectionView];
    
    [self loadData];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    _collectionNode.frame = self.node.bounds;
}

- (void)configureCollectionView
{
    if (_extendedTabBarInset) {
        _collectionNode.view.contentInset = UIEdgeInsetsMake(0, 0, 49, 0);
        _collectionNode.view.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 49, 0);
    }
    _collectionNode.frame = self.node.bounds;
    _collectionNode.view.backgroundColor = RGB_255(245, 245, 245);
    [_collectionNode.view registerSupplementaryNodeOfKind:UICollectionElementKindSectionHeader];

}

#pragma mark - loadData

- (void)loadData
{
    [LPLoadingView showLoadingInView:self.view];
    LPHttpRequest *hotZoneRequest = [LPGameZoneOperation requestZoneDiscuzWithIndex:_discuzId];
    [hotZoneRequest loadWithSuccessBlock:^(LPHttpRequest *request) {
        LPZoneDiscuzModel *discuzModel = request.responseObject.data;
        _discuzList = discuzModel.discuzList;
        
        [_collectionNode reloadData];
        [LPLoadingView hideLoadingForView:self.view];
    } failureBlock:^(id<TYRequestProtocol> request, NSError *error) {
        [LPLoadingView hideLoadingForView:self.view];
        __weak typeof(self) weakSelf = self;
        [LPLoadFailedView showLoadFailedInView:self.view retryHandle:^{
            [weakSelf loadData];
        }];
    }];
}


#pragma mark - ASCollectionDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return _discuzList.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    LPZoneDiscuzDetail *detailDiscuz = _discuzList[section];
    return detailDiscuz.detailList.count;
}

- (ASCellNodeBlock)collectionView:(ASCollectionView *)collectionView nodeBlockForItemAtIndexPath:(NSIndexPath *)indexPath
{
    LPZoneDiscuzDetail *detailDiscuz = _discuzList[indexPath.section];
    LPZoneDiscuzItem *item = detailDiscuz.detailList[indexPath.item];
    ASCellNode *(^cellNodeBlock)() = ^ASCellNode *() {
        LPZoneDiscuzCellNode *cellNode = [[LPZoneDiscuzCellNode alloc]initWithItem:item];
        return cellNode;
    };
    return cellNodeBlock;
 
}

- (ASCellNode *)collectionView:(ASCollectionView *)collectionView nodeForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        LPZoneDiscuzDetail *detailDiscuz = _discuzList[indexPath.section];
        NSString *title = detailDiscuz.type.typeName;
        LPDiscuzHeaderNode *cellNode = [[LPDiscuzHeaderNode alloc]initWithTitle:title];
        cellNode.preferredFrameSize = CGSizeMake(CGRectGetWidth(self.view.frame), 30);
        return cellNode;
    }
    return nil;
}

#pragma mark - ASCollectionDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    LPZoneDiscuzDetail *detailDiscuz = _discuzList[indexPath.section];
    LPZoneDiscuzItem *item = detailDiscuz.detailList[indexPath.item];
    LPDiscuzListController *discuzVC = [[LPDiscuzListController alloc]init];
    discuzVC.fid = @(item.fid).stringValue;
    [self.navigationController pushViewController:discuzVC animated:YES];
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 1;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 1;
}

- (ASSizeRange)collectionView:(ASCollectionView *)collectionView constrainedSizeForNodeAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize cellSize = CGSizeMake((CGRectGetWidth(collectionView.frame) - 1)/2, 70);
    return ASSizeRangeMake(cellSize,cellSize);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(CGRectGetWidth(self.view.frame), 30);
}


@end
