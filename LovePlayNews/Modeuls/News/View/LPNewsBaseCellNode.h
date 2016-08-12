//
//  LPNewsBaseCellNode.h
//  LovePlayNews
//
//  Created by tany on 16/8/12.
//  Copyright © 2016年 tany. All rights reserved.
//

#import <AsyncDisplayKit/AsyncDisplayKit.h>
#import "LPNewsInfoModel.h"

@interface LPNewsBaseCellNode : ASCellNode

@property (nonatomic, strong, readonly) LPNewsInfoModel *newsInfo;

- (instancetype)initWithNewsInfo:(LPNewsInfoModel *)newsInfo;

@end
