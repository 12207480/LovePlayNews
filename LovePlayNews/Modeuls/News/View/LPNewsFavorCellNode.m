//
//  LPNewsFavorCellNode.m
//  LovePlayNews
//
//  Created by tany on 16/8/16.
//  Copyright © 2016年 tany. All rights reserved.
//

#import "LPNewsFavorCellNode.h"

@interface LPNewsFavorCellNode ()

@property (nonatomic, strong) ASNetworkImageNode *imageNode;
@property (nonatomic, strong) ASTextNode *titleNode;
@property (nonatomic, strong) ASTextNode *timeInfoNode;
@property (nonatomic, strong) ASDisplayNode *underLineNode;

@property (nonatomic, strong) LPNewsFavorInfo *favor;

@end

@implementation LPNewsFavorCellNode

- (instancetype)initWithFavors:(LPNewsFavorInfo *)favorInfo
{
    if (self = [super init]) {
        _favor = favorInfo;
        
        [self addImageNode];
        
        [self addTitleNode];
        
        [self addTimeInfoNode];
        
        [self addUnderLineNode];
    }
    return self;
}

- (void)addImageNode
{
    ASNetworkImageNode *imageNode = [[ASNetworkImageNode alloc]init];
    imageNode.layerBacked = YES;
    imageNode.URL = [_favor.imgsrc appropriateImageURL];
    [self addSubnode:imageNode];
    _imageNode = imageNode;
}

- (void)addTitleNode
{
    ASTextNode *titleNode = [[ASTextNode alloc]init];
    titleNode.layerBacked = YES;
    titleNode.maximumNumberOfLines = 2;
    NSDictionary *attrs = @{ NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue" size:15.0f] ,NSForegroundColorAttributeName: RGB_255(46, 46, 46)};
    titleNode.attributedText = [[NSAttributedString alloc]initWithString:_favor.title attributes:attrs];
    [self addSubnode:titleNode];
    _titleNode = titleNode;

}

- (void)addTimeInfoNode
{
    ASTextNode *timeInfoNode = [[ASTextNode alloc]init];
    timeInfoNode.layerBacked = YES;
    timeInfoNode.maximumNumberOfLines = 1;
    NSDictionary *attrs = @{ NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue" size:12.0f] ,NSForegroundColorAttributeName: RGB_255(178, 178, 178)};
    timeInfoNode.attributedText = [[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@  %@",_favor.source,_favor.ptime] attributes:attrs];
    [self addSubnode:timeInfoNode];
    _timeInfoNode = timeInfoNode;
}

- (void)addUnderLineNode
{
    ASDisplayNode *underLineNode = [[ASDisplayNode alloc]init];
    underLineNode.layerBacked = YES;
    underLineNode.backgroundColor = RGB_255(223, 223, 223);
    [self addSubnode:underLineNode];
    _underLineNode = underLineNode;
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize
{
    _imageNode.preferredFrameSize = CGSizeMake(84, 63);
    _titleNode.flexShrink = YES;
    _underLineNode.preferredFrameSize = CGSizeMake(constrainedSize.max.width, 0.5);
    
    ASStackLayoutSpec *verContentStackLayout = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionVertical spacing:0 justifyContent:ASStackLayoutJustifyContentSpaceBetween alignItems:ASStackLayoutAlignItemsStart children:@[_titleNode,_timeInfoNode]];
    verContentStackLayout.flexShrink = YES;
    
    ASStackLayoutSpec *horStackLayout = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionHorizontal spacing:10 justifyContent:ASStackLayoutJustifyContentStart alignItems:ASStackLayoutAlignItemsStretch children:@[_imageNode,verContentStackLayout]];
    
    ASInsetLayoutSpec *insetLayout = [ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsMake(15, 10, 15, 10) child:horStackLayout];

    ASStackLayoutSpec *verStackLayout = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionVertical spacing:0 justifyContent:ASStackLayoutJustifyContentStart alignItems:ASStackLayoutAlignItemsStart children:@[insetLayout,_underLineNode]];
    return verStackLayout;
}

@end
