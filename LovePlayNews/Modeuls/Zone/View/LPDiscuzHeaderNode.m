//
//  LPDiscuzHeaderNode.m
//  LovePlayNews
//
//  Created by tany on 16/9/5.
//  Copyright © 2016年 tany. All rights reserved.
//

#import "LPDiscuzHeaderNode.h"

@interface LPDiscuzHeaderNode ()

// UI
@property (nonatomic, strong) ASTextNode *titleNode;

// Data
@property (nonatomic, strong) NSString *title;

@end

@implementation LPDiscuzHeaderNode

- (instancetype)initWithTitle:(NSString *)title
{
    if (self = [super init]) {
        _title = title;
        
        [self addTitleNode];
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
    NSDictionary *attrs = @{ NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue" size:13.0f] ,NSForegroundColorAttributeName: RGB_255(36, 36, 36)};
    titleNode.attributedText = [[NSAttributedString alloc]initWithString:_title attributes:attrs];
    [self addSubnode:titleNode];
    _titleNode = titleNode;
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize
{
    _titleNode.flexShrink = YES;
    ASInsetLayoutSpec *insetLayout = [ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsMake(5, 13, 0, 0) child:_titleNode];
    return insetLayout;
}

- (void)layout
{
    [super layout];
    
}

@end
