//
//  LPHotZoneModel.m
//  LovePlayNews
//
//  Created by tanyang on 16/9/4.
//  Copyright © 2016年 tany. All rights reserved.
//

#import "LPHotZoneModel.h"
#import "TYJSONModel.h"

@implementation LPHotZoneModel

+ (NSDictionary *)modelClassInArrayOrDictonary
{
    return @{@"focusList":[LPZoneFocus class],@"forumList":[LPZoneForum class],@"threadList":[LPZoneThread class]};
}

@end

@implementation LPZoneFocus

@end

@implementation LPZoneForum

+ (NSDictionary *)modelPropertyMapper
{
    return @{@"desc":@"description"};
}


@end

@implementation LPZoneThread

@end