//
//  LPNewsRequestOperation.m
//  LovePlayNews
//
//  Created by tany on 16/8/3.
//  Copyright © 2016年 tany. All rights reserved.
//

#import "LPGameNewsOperation.h"

@implementation LPGameNewsOperation

+ (LPHttpRequest *)requestNewsListWithTopId:(NSString *)topId pageIndex:(NSInteger)pageIndex
{
    int pageCount = 20;
    LPHttpRequest *request = [LPHttpRequest requestWithModelClass:[LPNewsInfoModel class]];
    if (topId.length > 0) {
        request.URLString = [NSString stringWithFormat:@"%@/%@/%ld/%d",NewsListURL,topId,(long)pageIndex*pageCount,pageCount];
    }else {
        request.URLString = [NSString stringWithFormat:@"%@%ld/%d",NewsListURL,(long)pageIndex*pageCount,pageCount];
    }
    return request;
}

+ (LPHttpRequest *)requestNewsDetailWithNewsId:(NSString *)newsId
{
    LPHttpRequest *request = [LPHttpRequest requestWithModelClass:[LPNewsDetailModel class]];
    request.URLString = [NSString stringWithFormat:@"%@/%@",NewsDetailURL,newsId];
    request.parameters = @{@"tieVersion":@"v2",@"platform":@"ios",@"width":@(kScreenWidth*2),@"height":@(kScreenHeight*2),@"decimal":@"75"};
    return request;
}

@end
