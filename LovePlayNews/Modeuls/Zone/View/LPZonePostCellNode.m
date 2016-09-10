//
//  LPZonePostCellNode.m
//  LovePlayNews
//
//  Created by tanyang on 16/9/4.
//  Copyright © 2016年 tany. All rights reserved.
//

#import "LPZonePostCellNode.h"

@interface LPZonePostCellNode ()

// UI
@property (nonatomic, strong) ASTextNode *titleNode;
@property (nonatomic, strong) ASDisplayNode *underLineNode;
@property (nonatomic, strong) ASTextNode *detailTextNode;

// Data
@property (nonatomic, strong) LPZoneThread *post;

@end

@implementation LPZonePostCellNode

- (instancetype)initWithPost:(LPZoneThread *)post
{
    if (self = [super init]) {
        _post = post;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self addTitleNode];
        
        [self addDetailTextNode];
        
        [self addUnderLineNode];
        
    }
    return self;
}

- (void)addTitleNode
{
    ASTextNode *titleNode = [[ASTextNode alloc]init];
    titleNode.placeholderEnabled = YES;
    titleNode.placeholderColor = RGB_255(245, 245, 245);
    titleNode.layerBacked = YES;
    titleNode.maximumNumberOfLines = 2;
    NSDictionary *attrs = @{ NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue" size:15.0f] ,NSForegroundColorAttributeName: RGB_255(36, 36, 36)};
    titleNode.attributedText = [[NSAttributedString alloc]initWithString:_post.title attributes:attrs];
    [self addSubnode:titleNode];
    _titleNode = titleNode;
}

- (void)addDetailTextNode
{
    ASTextNode *detailTextNode = [[ASTextNode alloc]init];
    detailTextNode.layerBacked = YES;
    detailTextNode.maximumNumberOfLines = 1;
    NSDictionary *attrs = @{ NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue" size:11.0f] ,NSForegroundColorAttributeName: RGB_255(150, 150, 150)};
    NSString *detailText = [NSString stringWithFormat:@"%@回复   %@   发表于%@",_post.replies,_post.author,_post.fname];
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc]initWithString:detailText attributes:attrs];
    [attributedText addAttribute:NSForegroundColorAttributeName value:RGB_255(129, 179, 252) range:[detailText rangeOfString:_post.fname]];
    detailTextNode.attributedText = [attributedText copy];
    [self addSubnode:detailTextNode];
    _detailTextNode = detailTextNode;
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
    _titleNode.flexShrink = YES;
    _underLineNode.preferredFrameSize = CGSizeMake(constrainedSize.max.width, 0.5);
    ASStackLayoutSpec *verTopStackLayout = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionVertical spacing:12 justifyContent:ASStackLayoutJustifyContentStart alignItems:ASStackLayoutAlignItemsStretch children:@[_titleNode,_detailTextNode]];
    ASInsetLayoutSpec *insetLayout = [ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsMake(10, 10, 10, 10) child:verTopStackLayout];
    ASStackLayoutSpec *verStackLayout = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionVertical spacing:0 justifyContent:ASStackLayoutJustifyContentStart alignItems:ASStackLayoutAlignItemsStretch children:@[insetLayout,_underLineNode]];
    return verStackLayout;
}

@end
