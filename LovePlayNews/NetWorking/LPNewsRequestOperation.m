//
//  LPNewsRequestOperation.m
//  LovePlayNews
//
//  Created by tany on 16/8/3.
//  Copyright © 2016年 tany. All rights reserved.
//

#import "LPNewsRequestOperation.h"

@implementation LPNewsRequestOperation

+ (LPHttpRequest *)requestNewsListWithTopId:(NSString *)topId pageIndex:(NSInteger)pageIndex
{
    LPHttpRequest *request = [LPHttpRequest requestWithModelClass:[LPNewsInfoModel class]];
    if (topId.length > 0) {
        request.URLString = [NSString stringWithFormat:@"%@/%@/%ld/%d",NewsListURL,topId,pageIndex*20,20];
    }else {
        request.URLString = [NSString stringWithFormat:@"%@%ld/%d",NewsListURL,pageIndex*20,20];
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
