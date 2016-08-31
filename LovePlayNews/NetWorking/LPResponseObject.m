//
//  TYResponseObject.m
//  TYHttpManagerDemo
//
//  Created by tany on 16/5/24.
//  Copyright © 2016年 tany. All rights reserved.
//

#import "LPResponseObject.h"
#import "TYJSONModel.h"

@interface LPResponseObject ()
@property (nonatomic, assign) Class modelClass;
@end

@implementation LPResponseObject

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
        return NO;
    }
    
    NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)request.dataTask.response;
    NSInteger responseStatusCode = [httpResponse statusCode];
    
    // StatusCode
    if (responseStatusCode < 200 || responseStatusCode > 299) {
        *error = [NSError errorWithDomain:@"invalid http request" code: responseStatusCode userInfo:nil];
        return NO;
    }
    
    // 根据 response 结构 应该为字典
    if (![response isKindOfClass:[NSDictionary class]]) {
        *error = [NSError errorWithDomain:@"response is invalide, is not NSDictionary" code:-1  userInfo:nil];
        return NO;
    }
    
    // 获取自定义的状态码
    NSInteger status = [[response objectForKey:@"code"] integerValue];
    if (status != TYStauteSuccessCode) {
        _status = status;
        _msg = [response objectForKey:@"message"];
        *error = [NSError errorWithDomain:_msg code:_status  userInfo:nil];
        return NO;
    }
    
    return YES;
}

- (id)parseResponse:(id)response request:(TYHttpRequest *)request
{
    _status = [[response objectForKey:@"code"] integerValue];
    _msg = [response objectForKey:@"message"];
    id json = [response objectForKey:@"info"];
    
    if (_modelClass) {
        if ([json isKindOfClass:[NSDictionary class]]) {
            _data = [[self modelClass] ty_ModelWithDictonary:json];
        }else if ([json isKindOfClass:[NSArray class]]) {
            _data = [[self modelClass] ty_ModelArrayWithDictionaryArray:json];
        }
    }else {
        _data = json;
    }
    return self;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"\nstatus:%d\nmsg:%@\n",(int)_status,_msg];
}


@end
