//
//  LPNewsReplayNode.h
//  LovePlayNews
//
//  Created by tany on 16/8/19.
//  Copyright © 2016年 tany. All rights reserved.
//

#import <AsyncDisplayKit/AsyncDisplayKit.h>
#import "LPNewsCommentModel.h"

@interface LPNewsReplyNode : ASDisplayNode

- (instancetype)initWithCommentItem:(LPNewsCommentItem *)item floor:(NSInteger)floor;

@end
