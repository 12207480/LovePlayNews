//
//  LPNewsCellNode.m
//  LovePlayNews
//
//  Created by tany on 16/8/4.
//  Copyright © 2016年 tany. All rights reserved.
//

#import "LPNewsCellNode.h"

@interface LPNewsCellNode ()
@property (nonatomic, strong) LPNewsInfoModel *newsInfo;
@property (nonatomic, strong) ASTextNode *titleNode;
@end

@implementation LPNewsCellNode

- (instancetype)initWithNewsInfo:(LPNewsInfoModel *)newsInfo
{
    if (self = [super init]) {
        _newsInfo = newsInfo;
        _titleNode = [[ASTextNode alloc]init];
        _titleNode.maximumNumberOfLines = 2;
        _titleNode.attributedText = [[NSAttributedString alloc]initWithString:newsInfo.title];
        [self addSubnode:_titleNode];
    }
    return self;
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize
{
    ASInsetLayoutSpec *insetLayout = [ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsMake(10, 10, 10, 10) child:_titleNode];
    return insetLayout;
}


@end
