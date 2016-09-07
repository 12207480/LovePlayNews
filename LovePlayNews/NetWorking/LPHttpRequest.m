//
//  TYModelRequest.m
//  TYHttpManagerDemo
//
//  Created by tany on 16/5/24.
//  Copyright © 2016年 tany. All rights reserved.
//

#import "LPHttpRequest.h"

@implementation LPHttpRequest

@dynamic responseObject;

- (instancetype)init
{
    if (self = [super init]) {
        self.baseURL = BaseURL;
        self.responseParser = [[TYResponseObject alloc]init];
    }
    return self;
}

- (instancetype)initWithModelClass:(Class)modelClass
{
    if (self = [super init]) {
        self.baseURL = BaseURL;
        self.responseParser = [[LPResponseObject alloc]initWithModelClass:modelClass];
    }
    return self;
}

+ (instancetype)requestWithModelClass:(Class)modelClass
{
    return [[self alloc]initWithModelClass:modelClass];
}

@end
