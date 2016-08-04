//
//  LPNewsCellNode.h
//  LovePlayNews
//
//  Created by tany on 16/8/4.
//  Copyright © 2016年 tany. All rights reserved.
//

#import <AsyncDisplayKit/AsyncDisplayKit.h>
#import "LPNewsInfoModel.h"

@interface LPNewsCellNode : ASCellNode

- (instancetype)initWithNewsInfo:(LPNewsInfoModel *)newsInfo;

@end
