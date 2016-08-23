//
//  LPNewsCommentCellNode.h
//  LovePlayNews
//
//  Created by tany on 16/8/12.
//  Copyright © 2016年 tany. All rights reserved.
//

#import <AsyncDisplayKit/AsyncDisplayKit.h>
#import "LPNewsCommentModel.h"

@interface LPNewsCommentCellNode : ASCellNode

- (instancetype)initWithCommentItem:(LPNewsCommentItem *)item;

- (instancetype)initWithCommentItems:(NSDictionary *)commentItems floors:(NSArray *)floors;

@end
