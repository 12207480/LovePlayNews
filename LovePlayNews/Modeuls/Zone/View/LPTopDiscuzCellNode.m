//
//  LPTopDiscuzCellNode.m
//  LovePlayNews
//
//  Created by tany on 16/9/7.
//  Copyright © 2016年 tany. All rights reserved.
//

#import "LPTopDiscuzCellNode.h"

@interface LPTopDiscuzCellNode ()

// Data
@property (nonatomic, strong) LPForumThread *item;

@end

@implementation LPTopDiscuzCellNode

- (instancetype)initWithItem:(LPForumThread *)item
{
    if (self = [super init]) {
        _item = item;
    }
    return self;
}

@end
