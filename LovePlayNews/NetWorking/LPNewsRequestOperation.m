//
//  LPNewsRequestOperation.m
//  LovePlayNews
//
//  Created by tany on 16/8/3.
//  Copyright © 2016年 tany. All rights reserved.
//

#import "LPNewsRequestOperation.h"

@implementation LPNewsRequestOperation

+ (TYModelRequest *)requestNewsListWithPageIndex:(NSInteger)pageIndex
{
    TYModelRequest *request = [TYModelRequest requestWithModelClass:[LPNewsInfoModel class]];
    request.URLString = [NSString stringWithFormat:@"%@%ld/%d",NewsListURL,pageIndex,20];
    return request;
}

@end
