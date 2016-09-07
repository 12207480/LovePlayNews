//
//  LPDiscuzDeailModel.m
//  LovePlayNews
//
//  Created by tany on 16/9/7.
//  Copyright © 2016年 tany. All rights reserved.
//

#import "LPDiscuzListModel.h"
#import "TYJSONModel.h"

@implementation LPDiscuzListModel

+ (NSDictionary *)modelClassInArrayOrDictonary
{
    return @{@"forum_threadlist":[LPForumThread class]};
}

@end


@implementation LPDiscuzforum

@end

@implementation LPForumThread

@end