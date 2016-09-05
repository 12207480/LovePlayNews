//
//  LPZoneDiscuzModel.m
//  LovePlayNews
//
//  Created by tany on 16/9/5.
//  Copyright © 2016年 tany. All rights reserved.
//

#import "LPZoneDiscuzModel.h"
#import "TYJSONModel.h"

@implementation LPZoneDiscuzModel

+ (NSDictionary *)modelClassInArrayOrDictonary
{
    return @{@"discuzList":[LPZoneDiscuzDetail class]};
}

@end

@implementation LPZoneDiscuzDetail

+ (NSDictionary *)modelClassInArrayOrDictonary
{
    return @{@"detailList":[LPZoneDiscuzItem class]};
}

@end

@implementation LPZoneDiscuzItem


@end

@implementation LPZoneDiscuzType


@end