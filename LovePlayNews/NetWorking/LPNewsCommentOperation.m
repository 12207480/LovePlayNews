//
//  LPNewsCommentOperation.m
//  LovePlayNews
//
//  Created by tany on 16/8/22.
//  Copyright © 2016年 tany. All rights reserved.
//

#import "LPNewsCommentOperation.h"
#import "LPCustomResponse.h"

@implementation LPNewsCommentOperation

+ (LPHttpRequest *)requestHotCommentWithNewsId:(NSString *)newsId
{
    LPHttpRequest *request = [[LPHttpRequest alloc]init];
    request.responseParser = [[LPCustomResponse alloc]initWithModelClass:[LPNewsCommentModel class]];
    request.URLString = [NSString stringWithFormat:@"%@%@/0/10/11/2/2",NewsHotCommentURL,newsId];
    return request;
}

+ (LPHttpRequest *)requestNewCommentWithNewsId:(NSString *)newsId pageIndex:(NSInteger)pageIndex
{
    int pageCount = 20;
    LPHttpRequest *request = [[LPHttpRequest alloc]init];
    request.responseParser = [[LPCustomResponse alloc]initWithModelClass:[LPNewsCommentModel class]];
    request.URLString = [NSString stringWithFormat:@"%@%@/%ld/%d/6/2/2",NewsNewCommentURL,newsId,(long)pageIndex*pageCount,pageCount];
    return request;
}

@end
