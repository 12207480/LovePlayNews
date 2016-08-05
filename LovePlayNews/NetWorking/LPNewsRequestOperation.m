//
//  LPNewsRequestOperation.m
//  LovePlayNews
//
//  Created by tany on 16/8/3.
//  Copyright © 2016年 tany. All rights reserved.
//

#import "LPNewsRequestOperation.h"

@implementation LPNewsRequestOperation

+ (TYModelRequest *)requestNewsListWithTopId:(NSString *)topId pageIndex:(NSInteger)pageIndex
{
    TYModelRequest *request = [TYModelRequest requestWithModelClass:[LPNewsInfoModel class]];
    if (topId.length > 0) {
        request.URLString = [NSString stringWithFormat:@"%@/%@/%ld/%d",NewsListURL,topId,pageIndex*20,20];
    }else {
        request.URLString = [NSString stringWithFormat:@"%@%ld/%d",NewsListURL,pageIndex*20,20];
    }
    return request;
}

@end
