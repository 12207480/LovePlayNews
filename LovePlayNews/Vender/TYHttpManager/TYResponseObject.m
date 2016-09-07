//
//  TYResponseObject.m
//  LovePlayNews
//
//  Created by tany on 16/9/7.
//  Copyright © 2016年 tany. All rights reserved.
//

#import "TYResponseObject.h"

@interface TYResponseObject ()

@property (nonatomic, assign) Class modelClass;

@end

@implementation TYResponseObject

- (instancetype)initWithModelClass:(Class)modelClass
{
    if (self = [super init]) {
        _modelClass = modelClass;
    }
    return self;
}

- (BOOL)isValidResponse:(id)response request:(TYHttpRequest *)request error:(NSError *__autoreleasing *)error
{
    if (!response) {
        *error = [NSError errorWithDomain:@"response is nil" code: -1 userInfo:nil];
        return NO;
    }
    
    NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)request.dataTask.response;
    NSInteger responseStatusCode = [httpResponse statusCode];
    
    // StatusCode
    if (responseStatusCode < 200 || responseStatusCode > 299) {
        *error = [NSError errorWithDomain:@"invalid http request" code: responseStatusCode userInfo:nil];
        return NO;
    }
    return YES;
}

- (id)parseResponse:(id)response request:(TYHttpRequest *)request
{
    _data = response;
    return  self;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"\nstatus:%d\nmsg:%@\n",(int)_status,_msg?_msg : @""];
}

@end
