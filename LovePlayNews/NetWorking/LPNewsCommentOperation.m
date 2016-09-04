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
    request.URLString = [NSString stringWithFormat:@"%@%@/0/10/11/2/2",HotGameCommentURL,newsId];
    return request;
}

+ (LPHttpRequest *)requestNewCommentWithNewsId:(NSString *)newsId pageIndex:(NSInteger)pageIndex pageSize:(NSInteger)pageSize
{
    LPHttpRequest *request = [[LPHttpRequest alloc]init];
    request.responseParser = [[LPCustomResponse alloc]initWithModelClass:[LPNewsCommentModel class]];
    request.URLString = [NSString stringWithFormat:@"%@%@/%ld/%d/6/2/2",NewGameCommentURL,newsId,(long)pageIndex*pageSize,(int)pageSize];
    return request;
}

@end
