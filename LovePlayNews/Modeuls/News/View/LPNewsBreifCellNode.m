//
//  LPNewsBreifCellNode.m
//  LovePlayNews
//
//  Created by tany on 16/8/11.
//  Copyright © 2016年 tany. All rights reserved.
//

#import "LPNewsBreifCellNode.h"

@interface LPNewsBreifCellNode ()

@property (nonatomic, strong) ASDisplayNode *leftLineNode;
@property (nonatomic, strong) ASTextNode *breifNode;

@property (nonatomic, strong) NSString *breif;

@end

@implementation LPNewsBreifCellNode

- (instancetype)initWithBreif:(NSString *)breif
{
    if (self = [super init]) {
        _breif = breif;
        
        [self addleftLineNode];
        
        [self addBreifNode];
    }
    return self;
}

- (void)addleftLineNode
{
    ASDisplayNode *leftLineNode = [ASDisplayNode new];
    leftLineNode.layerBacked  = YES;
    leftLineNode.backgroundColor = RGB_255(182, 140, 149);
    [self addSubnode:leftLineNode];
    _leftLineNode = leftLineNode;
}

- (void)addBreifNode
{
    ASTextNode *breifNode = [[ASTextNode alloc]init];
    breifNode.layerBacked = YES;
    breifNode.maximumNumberOfLines = 0;
    NSDictionary *attrs = @{ NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue" size:17.0f] ,NSForegroundColorAttributeName: RGB_255(182, 140, 149)};
    breifNode.attributedText = [[NSAttributedString alloc]initWithString:_breif attributes:attrs];
    [self addSubnode:breifNode];
    _breifNode = breifNode;
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize
{
    _leftLineNode.preferredFrameSize = CGSizeMake(2, constrainedSize.min.height);
    _breifNode.flexShrink = YES;
    ASStackLayoutSpec *horStackLayout = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionHorizontal spacing:8 justifyContent:ASStackLayoutJustifyContentStart alignItems:ASStackLayoutAlignItemsStretch children:@[_leftLineNode,_breifNode]];
    ASInsetLayoutSpec *insetLayout = [ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsMake(10, 10, 10, 10) child:horStackLayout];
    return insetLayout;
}

@end
