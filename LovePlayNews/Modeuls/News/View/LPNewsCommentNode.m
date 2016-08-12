//
//  LPNewsCommentCellNode.m
//  LovePlayNews
//
//  Created by tany on 16/8/12.
//  Copyright © 2016年 tany. All rights reserved.
//

#import "LPNewsCommentNode.h"

@interface LPNewsCommentNode ()

@property (nonatomic,strong) LPNewsCommonItem *item;


@end

@implementation LPNewsCommentNode

- (instancetype)initWithCommentItem:(LPNewsCommonItem *)item
{
    if (self = [super init]) {
        _item = item;
    }
    return self;
}

- (void)addImageNode
{
    
}

@end
