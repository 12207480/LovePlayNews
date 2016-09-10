//
//  LPNewsBaseCellNode.m
//  LovePlayNews
//
//  Created by tany on 16/8/12.
//  Copyright © 2016年 tany. All rights reserved.
//

#import "LPNewsBaseCellNode.h"

@interface LPNewsBaseCellNode ()

@property (nonatomic, strong) LPNewsInfoModel *newsInfo;

@end

@implementation LPNewsBaseCellNode

- (instancetype)initWithNewsInfo:(LPNewsInfoModel *)newsInfo
{
    if (self = [super init]) {
        _newsInfo = newsInfo;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

@end
