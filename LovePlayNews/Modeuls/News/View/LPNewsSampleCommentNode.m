//
//  LPNewsCommentCellNode.m
//  LovePlayNews
//
//  Created by tany on 16/8/12.
//  Copyright © 2016年 tany. All rights reserved.
//

#import "LPNewsSampleCommentNode.h"

@interface LPNewsSampleCommentNode ()
@property (nonatomic,strong) LPNewsCommonItem *item;
@end

@implementation LPNewsSampleCommentNode

- (instancetype)initWithCommentItem:(LPNewsCommonItem *)item
{
    if (self = [super init]) {
        _item = item;
    }
    return self;
}

@end
