//
//  TYResponseObject.m
//  TYHttpManagerDemo
//
//  Created by tany on 16/5/24.
//  Copyright © 2016年 tany. All rights reserved.
//

#import "LPResponseObject.h"
#import "TYJSONModel.h"

@implementation LPResponseObject

- (BOOL)isValidResponse:(id)response request:(TYHttpRequest *)request error:(NSError *__autoreleasing *)error
{
    if (![super isValidResponse:response request:request error:error]) {
        return NO;
    }
    
    // 根据 response 结构 应该为字典
    if (![response isKindOfClass:[NSDictionary class]]) {
        if (!self.modelClass) {
            // _modelClass nil
            self.status = TYStauteSuccessCode;
            return YES;
        }
        *error = [NSError errorWithDomain:@"response is invalide, is not NSDictionary" code:-1  userInfo:nil];
        return NO;
    }
    
    // 获取自定义的状态码
    NSInteger status = [response objectForKey:@"code"] ? [[response objectForKey:@"code"] integerValue] : TYStauteSuccessCode;
    
    if (status != TYStauteSuccessCode) {
        self.status = status;
        self.msg = [response objectForKey:@"message"];
        *error = [NSError errorWithDomain:self.msg code:self.status  userInfo:nil];
        return NO;
    }

    return YES;
}

- (id)parseResponse:(id)response request:(TYHttpRequest *)request
{
    if (![response isKindOfClass:[NSDictionary class]]) {
        // _modelClass nil
        self.status = TYStauteSuccessCode;
        return [super parseResponse:response request:request];
    }
    
    // json to model
    self.status = [response objectForKey:@"code"] ? [[response objectForKey:@"code"] integerValue] : TYStauteSuccessCode;
    self.msg = [response objectForKey:@"message"];
    id json = [response objectForKey:@"info"];
    
    if (self.modelClass) {
        if ([json isKindOfClass:[NSDictionary class]]) {
            self.data = [[self modelClass] ty_ModelWithDictonary:json];
        }else if ([json isKindOfClass:[NSArray class]]) {
            self.data = [[self modelClass] ty_ModelArrayWithDictionaryArray:json];
        }
    }else {
        // _modelClass nil
        self.data = json ? json : response;
    }
    return self;
}

@end
