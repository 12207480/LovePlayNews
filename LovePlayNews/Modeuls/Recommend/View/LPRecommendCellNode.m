//
//  LPRecommendCellNode.m
//  LovePlayNews
//
//  Created by tanyang on 16/8/27.
//  Copyright © 2016年 tany. All rights reserved.
//

#import "LPRecommendCellNode.h"

@interface LPRecommendCellNode ()

@property (nonatomic, strong) LPRecommendItem *item;

@property (nonatomic, strong) ASNetworkImageNode *imageNode;
@property (nonatomic, strong) ASTextNode *titleNode;

@end

@implementation LPRecommendCellNode

- (instancetype)initWithItem:(LPRecommendItem *)item
{
    if (self = [super init]) {
        _item = item;
        
        [self addImageNode];
        
        [self addTitleNode];
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
    NSDictionary *attrs = @{ NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue" size:12.0f] ,NSForegroundColorAttributeName: RGB_255(36, 36, 36)};
    titleNode.attributedText = [[NSAttributedString alloc]initWithString:_item.topicName ? _item.topicName :@"" attributes:attrs];
    [self addSubnode:titleNode];
    _titleNode = titleNode;
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize
{
    _imageNode.preferredFrameSize = CGSizeMake(78, 78);
    _titleNode.flexShrink = YES;
    ASStackLayoutSpec *verStackLayout = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionVertical spacing:8 justifyContent:ASStackLayoutJustifyContentStart alignItems:ASStackLayoutAlignItemsCenter children:@[_imageNode,_titleNode]];
    verStackLayout.flexShrink = YES;
    return verStackLayout;
}

@end
