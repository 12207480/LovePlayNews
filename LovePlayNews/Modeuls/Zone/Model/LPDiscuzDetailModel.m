//
//  LPDiscuzDetailModel.m
//  LovePlayNews
//
//  Created by tanyang on 16/9/8.
//  Copyright © 2016年 tany. All rights reserved.
//

#import "LPDiscuzDetailModel.h"
#import "TYJSONModel.h"

@implementation LPDiscuzDetailModel

+ (NSDictionary *)modelClassInArrayOrDictonary
{
    return @{@"postlist":[LPDiscuzPost class]};
}

@end

@implementation LPDiscuzThread

@end

@implementation LPDiscuzPost

@end

