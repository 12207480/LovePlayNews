//
//  LPDiscuzCellNode.h
//  LovePlayNews
//
//  Created by tany on 16/9/7.
//  Copyright © 2016年 tany. All rights reserved.
//

#import <AsyncDisplayKit/AsyncDisplayKit.h>
#import "LPDiscuzListModel.h"

@interface LPDiscuzCellNode : ASCellNode

- (instancetype)initWithItem:(LPForumThread *)item;

@end
