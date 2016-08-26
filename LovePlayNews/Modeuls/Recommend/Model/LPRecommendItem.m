//
//  LPRecommendItem.m
//  LovePlayNews
//
//  Created by tany on 16/8/26.
//  Copyright © 2016年 tany. All rights reserved.
//

#import "LPRecommendItem.h"
#import "TYJSONModel.h"

@implementation LPRecommendItem

+ (NSDictionary *)modelPropertyMapper
{
    return @{@"desc":@"description"};
}

@end
