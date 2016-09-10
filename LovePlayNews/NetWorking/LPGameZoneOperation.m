//
//  LPNewsZoneOperation.m
//  LovePlayNews
//
//  Created by tanyang on 16/9/4.
//  Copyright © 2016年 tany. All rights reserved.
//

#import "LPGameZoneOperation.h"
#import "LPDiscuzResponse.h"

@implementation LPGameZoneOperation

+ (LPHttpRequest *)requestHotZoneWithPageIndex:(NSInteger)pageIndex
{
    int pageSize = 20;
    LPHttpRequest *request = [LPHttpRequest requestWithModelClass:[LPHotZoneModel class]];
    request.URLString = [NSString stringWithFormat:@"%@/%ld/%d",HotGameZoneURL,(long)pageIndex,pageSize];
    return request;
}

+ (LPHttpRequest *)requestZoneDiscuzWithIndex:(NSInteger)index
{
    LPHttpRequest *request = [LPHttpRequest requestWithModelClass:[LPZoneDiscuzModel class]];
    request.URLString = [NSString stringWithFormat:@"%@/%ld",ZoneDiscuzURL,(long)index];
    return request;
}

+ (LPHttpRequest *)requestDiscuzListWithFid:(NSString *)fid Index:(NSInteger)index
{
    LPHttpRequest *request = [[LPHttpRequest alloc]init];
    request.responseParser = [[LPDiscuzResponse alloc] initWithModelClass:[LPDiscuzListModel class]];
    request.URLString = [NSString stringWithFormat:@"%@",DiscuzDetailURL];
    request.parameters = @{@"version":@"163",@"module":@"forumdisplay",@"fid":fid?fid:@"",@"tpp":@"15",@"charset":@"utf-8",@"page":@(index).stringValue};
    return request;
}

+ (LPHttpRequest *)requestDiscuzDetailWithTid:(NSString *)tid index:(NSInteger)index pageSize:(NSInteger)pageSize
{
    LPHttpRequest *request = [[LPHttpRequest alloc]init];
    request.responseParser = [[LPDiscuzResponse alloc] initWithModelClass:[LPDiscuzDetailModel class]];
    request.URLString = [NSString stringWithFormat:@"%@",DiscuzDetailURL];
    request.parameters = @{@"version":@"163",@"module":@"viewthread",@"tid":tid?tid:@"",@"ppp":@(pageSize).stringValue,@"charset":@"utf-8",@"page":@(index).stringValue};
    return request;
}

+ (LPHttpRequest *)requestDiscuzImageWithFid:(NSString *)fid
{
    LPHttpRequest *request = [LPHttpRequest requestWithModelClass:[LPZoneDiscuzItem class]];
    request.URLString = [NSString stringWithFormat:@"%@/%@",ZoneDiscuzImageURL,fid];
    return request;
}

@end
