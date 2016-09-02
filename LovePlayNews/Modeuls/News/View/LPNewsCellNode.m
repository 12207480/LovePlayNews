//
//  LPNewsCellNode.m
//  LovePlayNews
//
//  Created by tany on 16/8/4.
//  Copyright © 2016年 tany. All rights reserved.
//

#import "LPNewsCellNode.h"
#import <YYWebImage.h>

@interface LPNewsCellNode ()

@property (nonatomic, strong) ASTextNode *titleNode;
@property (nonatomic, strong) ASDisplayNode *imageNode;
@property (nonatomic, strong) ASDisplayNode *underLineNode;
@property (nonatomic, strong) ASImageNode *replyImageNode;
@property (nonatomic, strong) ASTextNode *replyTextNode;
@property (nonatomic, weak) UIImageView *imageView;
@end

@implementation LPNewsCellNode

- (instancetype)initWithNewsInfo:(LPNewsInfoModel *)newsInfo
{
    if (self = [super initWithNewsInfo:newsInfo]) {
        
        [self addTitleNode];
        
        [self addImageNode];
        
        [self addUnderLineNode];
        
        [self addReplyTextNode];
        
        [self addReplyImageNode];
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
    titleNode.placeholderEnabled = YES;
    titleNode.placeholderColor = RGB_255(245, 245, 245);
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

- (void)addReplyImageNode
{
    ASImageNode *replyImageNode = [[ASImageNode alloc]init];
    replyImageNode.layerBacked = YES;
    replyImageNode.contentMode = UIViewContentModeCenter;
    replyImageNode.image = [UIImage imageNamed:@"common_chat_new"];
    [self addSubnode:replyImageNode];
    _replyImageNode = replyImageNode;
}

- (void)addReplyTextNode
{
    ASTextNode *replyTextNode = [[ASTextNode alloc]init];
    replyTextNode.layerBacked = YES;
    replyTextNode.maximumNumberOfLines = 1;
    NSDictionary *attrs = @{ NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue" size:10.0f] ,NSForegroundColorAttributeName: RGB_255(150, 150, 150)};
    replyTextNode.attributedText = [[NSAttributedString alloc]initWithString:@(self.newsInfo.replyCount).stringValue attributes:attrs];
    [self addSubnode:replyTextNode];
    _replyTextNode = replyTextNode;
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize
{
    _imageNode.preferredFrameSize = CGSizeMake(84, 62);
    _titleNode.flexShrink = YES;
    _underLineNode.preferredFrameSize = CGSizeMake(constrainedSize.max.width, 0.5);
    _replyImageNode.preferredFrameSize = CGSizeMake(11, 11);
    
    ASStackLayoutSpec *horReplayStackLayout = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionHorizontal spacing:5 justifyContent:ASStackLayoutJustifyContentStart alignItems:ASStackLayoutAlignItemsCenter children:@[_replyImageNode,_replyTextNode]];
    
    ASStackLayoutSpec *verContentStackLayout = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionVertical spacing:0 justifyContent:ASStackLayoutJustifyContentSpaceBetween alignItems:ASStackLayoutAlignItemsStart children:@[_titleNode,horReplayStackLayout]];
    verContentStackLayout.flexShrink = YES;
    
    ASStackLayoutSpec *horStackLayout = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionHorizontal spacing:10 justifyContent:ASStackLayoutJustifyContentStart alignItems:ASStackLayoutAlignItemsStretch children:@[_imageNode,verContentStackLayout]];
    
     ASInsetLayoutSpec *insetLayout = [ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsMake(10, 10, 10, 10) child:horStackLayout];
    
    ASStackLayoutSpec *verStackLayout = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionVertical spacing:0 justifyContent:ASStackLayoutJustifyContentStart alignItems:ASStackLayoutAlignItemsStart children:@[insetLayout,_underLineNode]];
    return verStackLayout;
}

- (void)layout
{
    [super layout];
    _imageView.frame = _imageNode.frame;
}

@end
