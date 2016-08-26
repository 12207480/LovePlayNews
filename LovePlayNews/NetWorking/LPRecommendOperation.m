//
//  LPRecommendOperation.m
//  LovePlayNews
//
//  Created by tany on 16/8/26.
//  Copyright © 2016年 tany. All rights reserved.
//

#import "LPRecommendOperation.h"
#import "LPRecommendItem.h"
#import "LPTopicImageInfo.h"

@implementation LPRecommendOperation

+ (LPHttpRequest *)requestRecommendTopicList
{
    LPHttpRequest *request = [LPHttpRequest requestWithModelClass:[LPRecommendItem class]];
    request.URLString = [NSString stringWithFormat:@"%@",NewsRecommendTopicURL];
    return request;
}

+ (LPHttpRequest *)requestRecommendImageInfos
{
    LPHttpRequest *request = [LPHttpRequest requestWithModelClass:[LPTopicImageInfo class]];
    request.URLString = [NSString stringWithFormat:@"%@",NewsRecommendImageInfosURL];
    return request;
}

@end
