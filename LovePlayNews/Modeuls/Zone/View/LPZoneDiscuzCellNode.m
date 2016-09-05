//
//  LPDiscuzCellNode.m
//  LovePlayNews
//
//  Created by tany on 16/9/5.
//  Copyright © 2016年 tany. All rights reserved.
//

#import "LPZoneDiscuzCellNode.h"

@interface LPZoneDiscuzCellNode ()

// UI
@property (nonatomic, strong) ASTextNode *titleNode;
@property (nonatomic, strong) ASTextNode *detailTextNode;
@property (nonatomic, strong) ASNetworkImageNode *imageNode;

// Data
@property (nonatomic, strong) LPZoneDiscuzItem *item;

@end

@implementation LPZoneDiscuzCellNode

- (instancetype)initWithItem:(LPZoneDiscuzItem *)item
{
    if (self = [super init]) {
        _item = item;
        
        self.backgroundColor = [UIColor whiteColor];
        
        [self addImageNode];
        
        [self addTitleNode];
        
        [self addDetailTextNode];
    }
    return self;
}

- (void)addImageNode
{
    ASNetworkImageNode *imageNode = [[ASNetworkImageNode alloc]init];
    imageNode.placeholderEnabled = YES;
    imageNode.placeholderColor = RGB_255(245, 245, 245);
    imageNode.layerBacked = YES;
    imageNode.URL = [_item.iconUrl appropriateImageURL];
    [self addSubnode:imageNode];
    _imageNode = imageNode;
}

- (void)addTitleNode
{
    ASTextNode *titleNode = [[ASTextNode alloc]init];
    titleNode.placeholderEnabled = YES;
    titleNode.placeholderColor = RGB_255(245, 245, 245);
    titleNode.layerBacked = YES;
    titleNode.maximumNumberOfLines = 1;
    NSDictionary *attrs = @{ NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue" size:15.0f] ,NSForegroundColorAttributeName: RGB_255(36, 36, 36)};
    titleNode.attributedText = [[NSAttributedString alloc]initWithString:_item.modelName attributes:attrs];
    [self addSubnode:titleNode];
    _titleNode = titleNode;
}

- (void)addDetailTextNode
{
    ASTextNode *detailTextNode = [[ASTextNode alloc]init];
    detailTextNode.layerBacked = YES;
    detailTextNode.maximumNumberOfLines = 1;
    NSDictionary *attrs = @{ NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue" size:11.0f] ,NSForegroundColorAttributeName: RGB_255(150, 150, 150)};
     detailTextNode.attributedText = [[NSAttributedString alloc]initWithString:_item.modelDesc attributes:attrs];
    [self addSubnode:detailTextNode];
    _detailTextNode = detailTextNode;
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize
{
    _imageNode.preferredFrameSize = CGSizeMake(54, 54);
    _titleNode.flexShrink = YES;
    _detailTextNode.flexShrink = YES;
    
    ASStackLayoutSpec *verStackLayout = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionVertical spacing:10 justifyContent:ASStackLayoutJustifyContentStart alignItems:ASStackLayoutAlignItemsStretch children:@[_titleNode,_detailTextNode]];
    
    ASStackLayoutSpec *horStackLayout = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionHorizontal spacing:10 justifyContent:ASStackLayoutJustifyContentStart alignItems:ASStackLayoutAlignItemsCenter children:@[_imageNode,verStackLayout]];
    
    ASInsetLayoutSpec *insetLayout = [ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsMake(10, 13, 10, 10) child:horStackLayout];
    return insetLayout;
}

@end
