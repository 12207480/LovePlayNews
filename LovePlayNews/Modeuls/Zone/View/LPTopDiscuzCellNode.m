//
//  LPTopDiscuzCellNode.m
//  LovePlayNews
//
//  Created by tany on 16/9/7.
//  Copyright © 2016年 tany. All rights reserved.
//

#import "LPTopDiscuzCellNode.h"

@interface LPTopDiscuzCellNode ()

// UI
@property (nonatomic, strong) ASTextNode *titleNode;
@property (nonatomic, strong) ASButtonNode *topBtnNode;
@property (nonatomic, strong) ASDisplayNode *underLineNode;

// Data
@property (nonatomic, strong) LPForumThread *item;

@end

@implementation LPTopDiscuzCellNode

- (instancetype)initWithItem:(LPForumThread *)item
{
    if (self = [super init]) {
        _item = item;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self addTitleNode];
        
        [self addTopButton];
        
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
    titleNode.maximumNumberOfLines = 1;
    NSDictionary *attrs = @{ NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue" size:14.0f] ,NSForegroundColorAttributeName: RGB_255(36, 36, 36)};
    titleNode.attributedText = [[NSAttributedString alloc]initWithString:_item.subject attributes:attrs];
    [self addSubnode:titleNode];
    _titleNode = titleNode;
}

- (void)addTopButton
{
    ASButtonNode *topBtnNode = [[ASButtonNode alloc]init];
    topBtnNode.userInteractionEnabled = NO;
    topBtnNode.cornerRadius = 4;
    topBtnNode.clipsToBounds = YES;
    [topBtnNode setTitle:@"顶置贴" withFont:[UIFont systemFontOfSize:12] withColor:RGB_255(236, 126, 150) forState:ASControlStateNormal];
    [self addSubnode:topBtnNode];
    _topBtnNode = topBtnNode;
}

- (void)addUnderLineNode
{
    ASDisplayNode *underLineNode = [[ASDisplayNode alloc]init];
    underLineNode.layerBacked = YES;
    underLineNode.backgroundColor = RGB_255(223, 223, 223);
    [self addSubnode:underLineNode];
    _underLineNode = underLineNode;
}

- (void)didLoad
{
    [super didLoad];
    _topBtnNode.layer.borderWidth = 1;
    _topBtnNode.layer.borderColor = RGB_255(236, 126, 150).CGColor;
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize
{
    _titleNode.flexShrink = YES;
    _topBtnNode.preferredFrameSize = CGSizeMake(43, 22);
    _underLineNode.preferredFrameSize = CGSizeMake(constrainedSize.max.width, 0.5);
    ASStackLayoutSpec *horTopStackLayout = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionHorizontal spacing:6 justifyContent:ASStackLayoutJustifyContentStart alignItems:ASStackLayoutAlignItemsCenter children:@[_topBtnNode,_titleNode]];
    ASInsetLayoutSpec *insetLayout = [ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsMake(10, 13, 10, 13) child:horTopStackLayout];
    ASStackLayoutSpec *verStackLayout = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionVertical spacing:0 justifyContent:ASStackLayoutJustifyContentStart alignItems:ASStackLayoutAlignItemsStretch children:@[insetLayout,_underLineNode]];
    return verStackLayout;
}

@end
