//
//  LPNewsReplayNode.h
//  LovePlayNews
//
//  Created by tany on 16/8/19.
//  Copyright © 2016年 tany. All rights reserved.
//

#import <AsyncDisplayKit/AsyncDisplayKit.h>
#import "LPNewsCommonModel.h"

@interface LPNewsReplyNode : ASDisplayNode

- (instancetype)initWithCommentItem:(LPNewsCommonItem *)item floor:(NSInteger)floor;

@end
