//
//  LPNewsZoneOperation.m
//  LovePlayNews
//
//  Created by tanyang on 16/9/4.
//  Copyright © 2016年 tany. All rights reserved.
//

#import "LPGameZoneOperation.h"

@implementation LPGameZoneOperation

+ (LPHttpRequest *)requestHotZoneWithPageIndex:(NSInteger)pageIndex
{
    int pageSize = 20;
    LPHttpRequest *request = [LPHttpRequest requestWithModelClass:[LPHotZoneModel class]];
    request.URLString = [NSString stringWithFormat:@"%@/%ld/%d",HotGameZoneURL,(long)pageIndex,pageSize];
    return request;
}

@end
