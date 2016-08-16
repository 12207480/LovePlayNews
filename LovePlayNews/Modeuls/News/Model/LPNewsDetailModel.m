//
//  LPNewsDetailModel.m
//  LovePlayNews
//
//  Created by tany on 16/8/10.
//  Copyright © 2016年 tany. All rights reserved.
//

#import "LPNewsDetailModel.h"
#import "TYJSONModel.h"

@implementation LPNewsDetailModel

@end

@implementation LPNewsArticleModel

+ (NSDictionary *)modelClassInArrayOrDictonary
{
    return @{@"img":[LPNewsDetailImgeInfo class],@"relative_sys":[LPNewsFavorInfo class]};
}

@end

@implementation LPNewsDetailImgeInfo

@end

@implementation LPNewsFavorInfo

@end