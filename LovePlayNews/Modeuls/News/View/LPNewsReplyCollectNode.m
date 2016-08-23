//
//  LPNewsReplayCollectNode.m
//  LovePlayNews
//
//  Created by tany on 16/8/19.
//  Copyright © 2016年 tany. All rights reserved.
//

#import "LPNewsReplyCollectNode.h"
#import "LPNewsReplyNode.h"

@interface LPNewsReplyCollectNode ()

// Data
@property (nonatomic, strong) NSDictionary *commentItems;
@property (nonatomic, strong) NSArray *floors;

// UI
@property (nonatomic, strong) NSArray *replayNodes;

@end

@implementation LPNewsReplyCollectNode

- (instancetype)initWithCommentItems:(NSDictionary *)commentItems floors:(NSArray *)floors
{
    if (self = [super init]) {
        _commentItems = commentItems;
        _floors = floors;
        self.backgroundColor = RGB_255(248, 249, 241);
        [self addReplayNodes];
    }
    return self;
}

- (void)addReplayNodes
{
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:_floors.count];
    NSInteger count = _floors.count;
    NSInteger idx = 0;
    NSInteger floorIdx = 0;
    for (NSString *floor in _floors) {
        if (idx < count-1) {
            LPNewsCommentItem *item = [_commentItems objectForKey:floor];
            if (item.content) {
                LPNewsReplyNode *node = [[LPNewsReplyNode alloc]initWithCommentItem:item floor:floorIdx+1];
                node.layerBacked = YES;
                [self addSubnode:node];
                [array addObject:node];
                ++floorIdx;
            }
        }
        ++idx;
    }
    
    _replayNodes = [array copy];
}

- (void)didLoad
{
    [super didLoad];
    self.layer.borderColor = RGB_255(218, 218, 218).CGColor;
    self.layer.borderWidth = 0.5;
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize
{
    ASStackLayoutSpec *verStackLayout = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionVertical spacing:0 justifyContent:ASStackLayoutJustifyContentStart alignItems:ASStackLayoutAlignItemsStretch children:_replayNodes];
    return verStackLayout;
}

@end
