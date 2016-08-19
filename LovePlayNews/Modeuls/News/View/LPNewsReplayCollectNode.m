//
//  LPNewsReplayCollectNode.m
//  LovePlayNews
//
//  Created by tany on 16/8/19.
//  Copyright © 2016年 tany. All rights reserved.
//

#import "LPNewsReplayCollectNode.h"
#import "LPNewsReplayNode.h"

@interface LPNewsReplayCollectNode ()

// Data
@property (nonatomic, strong) NSDictionary *commentItems;
@property (nonatomic, strong) NSArray *floors;

// UI
@property (nonatomic, strong) NSArray *replayNodes;

@end

@implementation LPNewsReplayCollectNode

- (instancetype)initWithCommentItems:(NSDictionary *)commentItems floors:(NSArray *)floors
{
    if (self = [super init]) {
        _commentItems = commentItems;
        _floors = floors;
        
        [self addReplayNodes];
    }
    return self;
}

- (void)addReplayNodes
{
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:_floors.count];
    [_floors enumerateObjectsUsingBlock:^(LPNewsCommonItem *item, NSUInteger idx, BOOL *stop) {
        LPNewsReplayNode *node = [[LPNewsReplayNode alloc]initWithCommentItem:item floor:idx];
        [array addObject:node];
    }];
    _replayNodes = [array copy];
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize
{
    ASStackLayoutSpec *verStackLayout = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionVertical spacing:0 justifyContent:ASStackLayoutJustifyContentStart alignItems:ASStackLayoutAlignItemsStretch children:_replayNodes];
    return verStackLayout;
}

@end
