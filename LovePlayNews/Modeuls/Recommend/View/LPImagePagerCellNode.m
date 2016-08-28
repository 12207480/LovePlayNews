//
//  LPImagePagerNode.m
//  LovePlayNews
//
//  Created by tanyang on 16/8/27.
//  Copyright © 2016年 tany. All rights reserved.
//

#import "LPImagePagerCellNode.h"
#import "LPImageInfoCellNode.h"

@interface LPImagePagerCellNode ()<ASPagerDataSource, ASPagerDelegate>

@property (nonatomic, strong) NSArray *imageInfos;

@property (nonatomic, strong) ASPagerNode *pagerNode;

@end

@implementation LPImagePagerCellNode

- (instancetype)initWithImageInfos:(NSArray *)imageInfos
{
    if (self = [super init]) {
        _imageInfos = imageInfos;
        self.userInteractionEnabled = YES;
        [self addPagerNode];
    }
    return self;
}

- (void)addPagerNode
{
    ASPagerFlowLayout *flowLayout = [[ASPagerFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.minimumLineSpacing = 10;
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 15, 0, 15);
    ASPagerNode *pagerNode = [[ASPagerNode alloc]initWithCollectionViewLayout:flowLayout];
    pagerNode.dataSource = self;
    pagerNode.delegate = self;
    
    [self addSubnode:pagerNode];
    _pagerNode = pagerNode;
}

- (void)didLoad
{
    [super didLoad];
    _pagerNode.view.pagingEnabled = NO;
    _pagerNode.view.allowsSelection = YES;
    [_pagerNode reloadData];
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize
{
    ASInsetLayoutSpec *insetLayout = [ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsZero child:_pagerNode];
    return insetLayout;
}

#pragma mark - ASPagerDataSource

- (NSInteger)numberOfPagesInPagerNode:(ASPagerNode *)pagerNode
{
    return _imageInfos.count;
}

- (ASCellNodeBlock)pagerNode:(ASPagerNode *)pagerNode nodeBlockAtIndex:(NSInteger)index
{
    LPTopicImageInfo *imageInfo = _imageInfos[index];
    ASCellNode *(^cellNodeBlock)() = ^ASCellNode *() {
        LPImageInfoCellNode *cellNode = [[LPImageInfoCellNode alloc]initWithImageInfo:imageInfo];
        return cellNode;
    };
    return cellNodeBlock;
}

- (ASSizeRange)pagerNode:(ASPagerNode *)pagerNode constrainedSizeForNodeAtIndexPath:(NSIndexPath *)indexPath
{
    return ASSizeRangeMake(CGSizeMake(267, 113),CGSizeMake(267, 113));
}

#pragma mark - ASPagerDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (_didSelectImageInfoHandle) {
        _didSelectImageInfoHandle(_imageInfos[indexPath.row]);
    }
}

@end
