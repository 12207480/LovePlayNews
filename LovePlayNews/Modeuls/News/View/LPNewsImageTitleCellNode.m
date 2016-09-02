//
//  LPNewsImageTitleCellNode.m
//  LovePlayNews
//
//  Created by tany on 16/8/30.
//  Copyright © 2016年 tany. All rights reserved.
//

#import "LPNewsImageTitleCellNode.h"
#import <YYWebImage.h>

@interface LPNewsImageTitleCellNode ()
@property (nonatomic, strong) ASTextNode *titleNode;
@property (nonatomic, strong) ASDisplayNode *imageNode;
@property (nonatomic, strong) ASImageNode *replyImageNode;
@property (nonatomic, strong) ASTextNode *replyTextNode;
@property (nonatomic, strong) ASTextNode *timeNode;
@property (nonatomic, weak) UIImageView *imageView;

@end

@implementation LPNewsImageTitleCellNode

- (instancetype)initWithNewsInfo:(LPNewsInfoModel *)newsInfo
{
    if (self = [super initWithNewsInfo:newsInfo]) {
        
        [self addTitleNode];
        
        [self addImageNode];
        
        [self addTimeNode];
        
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
    NSDictionary *attrs = @{ NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue-bold" size:16.0f] ,NSForegroundColorAttributeName: RGB_255(36, 36, 36)};
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

- (void)addTimeNode
{
    ASTextNode *timeNode = [[ASTextNode alloc]init];
    timeNode.layerBacked = YES;
    timeNode.maximumNumberOfLines = 1;
    NSDictionary *attrs = @{ NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue" size:12.0f] ,NSForegroundColorAttributeName: RGB_255(150, 150, 150)};
    NSString *time = self.newsInfo.ptime.length > 10 ? [self.newsInfo.ptime substringToIndex:10]:self.newsInfo.ptime;
    timeNode.attributedText = [[NSAttributedString alloc]initWithString:time attributes:attrs];
    [self addSubnode:timeNode];
    _timeNode = timeNode;
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
    NSDictionary *attrs = @{ NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue" size:12.0f] ,NSForegroundColorAttributeName: RGB_255(150, 150, 150)};
    replyTextNode.attributedText = [[NSAttributedString alloc]initWithString:@(self.newsInfo.replyCount).stringValue attributes:attrs];
    [self addSubnode:replyTextNode];
    _replyTextNode = replyTextNode;
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize
{
    _imageNode.preferredFrameSize = CGSizeMake(constrainedSize.max.width, 160);
    _titleNode.flexShrink = YES;
    _replyImageNode.preferredFrameSize = CGSizeMake(12, 12);
    
    ASStackLayoutSpec *horReplayStackLayout = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionHorizontal spacing:5 justifyContent:ASStackLayoutJustifyContentStart alignItems:ASStackLayoutAlignItemsCenter children:@[_replyImageNode,_replyTextNode]];
    
    ASStackLayoutSpec *horBottomStackLayout = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionHorizontal spacing:0 justifyContent:ASStackLayoutJustifyContentSpaceBetween alignItems:ASStackLayoutAlignItemsStretch children:@[_timeNode,horReplayStackLayout]];
    horBottomStackLayout.flexGrow = YES;
    
     ASStackLayoutSpec *verBottomStackLayout = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionVertical spacing:12 justifyContent:ASStackLayoutJustifyContentStart alignItems:ASStackLayoutAlignItemsStretch children:@[_titleNode,horBottomStackLayout]];
    verBottomStackLayout.flexGrow = YES;
    
    ASInsetLayoutSpec *insetLayout = [ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsMake(0, 15, 12, 15) child:verBottomStackLayout];
    
    ASStackLayoutSpec *verStackLayout = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionVertical spacing:12 justifyContent:ASStackLayoutJustifyContentStart alignItems:ASStackLayoutAlignItemsStretch children:@[_imageNode,insetLayout]];
    
    return verStackLayout;
}

- (void)layout
{
    [super layout];
    _imageView.frame = _imageNode.frame;
}

@end
