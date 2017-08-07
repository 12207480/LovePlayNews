//
//  LPNewsImageCellNode.m
//  LovePlayNews
//
//  Created by tany on 16/8/12.
//  Copyright © 2016年 tany. All rights reserved.
//

#import "LPNewsImageCellNode.h"
#import <YYWebImage.h>

@interface LPNewsImageCellNode ()
@property (nonatomic, strong) ASTextNode *titleNode;
@property (nonatomic, strong) ASDisplayNode *imageNode;
@property (nonatomic, strong) ASDisplayNode *underLineNode;
@property (nonatomic, weak) UIImageView *imageView;
@end

@implementation LPNewsImageCellNode

- (instancetype)initWithNewsInfo:(LPNewsInfoModel *)newsInfo
{
    if (self = [super initWithNewsInfo:newsInfo]) {
        
        [self addTitleNode];
        
        [self addImageNode];
        
        [self addUnderLineNode];
    }
    return self;
}

- (void)didLoad
{
    [super didLoad];
    
    [self addImageView];
}

- (void)addImageView
{
    UIImageView *imageView = [[UIImageView alloc]init];
    imageView.backgroundColor = RGB_255(245, 245, 245);
    imageView.yy_imageURL = [self.newsInfo.imgsrc.firstObject appropriateImageURL];
    [self.view addSubview:imageView];
    _imageView = imageView;
}

- (void)addTitleNode
{
    ASTextNode *titleNode = [[ASTextNode alloc]init];
    titleNode.placeholderColor = RGB_255(245, 245, 245);
    titleNode.placeholderEnabled = YES;
    titleNode.layerBacked = YES;
    titleNode.maximumNumberOfLines = 2;
    NSDictionary *attrs = @{ NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue" size:15.0f] ,NSForegroundColorAttributeName: RGB_255(36, 36, 36)};
    titleNode.attributedText = [[NSAttributedString alloc]initWithString:self.newsInfo.title attributes:attrs];
    [self addSubnode:titleNode];
    _titleNode = titleNode;
}

- (void)addImageNode
{
    ASDisplayNode *imageNode = [[ASDisplayNode alloc]init];
    imageNode.layerBacked = YES;
    [self addSubnode:imageNode];
    _imageNode = imageNode;
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
    CGFloat width = constrainedSize.max.width > 0 ? constrainedSize.max.width : [UIScreen mainScreen].bounds.size.width;
    _imageNode.preferredFrameSize = CGSizeMake(width-2*10, 118);
    _titleNode.flexShrink = YES;
    ASStackLayoutSpec *verTopStackLayout = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionVertical spacing:10 justifyContent:ASStackLayoutJustifyContentStart alignItems:ASStackLayoutAlignItemsStretch children:@[_titleNode,_imageNode]];
    ASInsetLayoutSpec *insetLayout = [ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsMake(10, 10, 10, 10) child:verTopStackLayout];
    
    _underLineNode.preferredFrameSize = CGSizeMake(constrainedSize.max.width, 0.5);
    ASStackLayoutSpec *verStackLayout = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionVertical spacing:0 justifyContent:ASStackLayoutJustifyContentStart alignItems:ASStackLayoutAlignItemsStart children:@[insetLayout,_underLineNode]];
    return verStackLayout;
}

- (void)layout
{
    [super layout];
    _imageView.frame = _imageNode.frame;
}

@end
