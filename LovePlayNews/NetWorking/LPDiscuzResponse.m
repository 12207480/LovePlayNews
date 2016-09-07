//
//  LPDiscuzResponse.m
//  LovePlayNews
//
//  Created by tany on 16/9/7.
//  Copyright © 2016年 tany. All rights reserved.
//

#import "LPDiscuzResponse.h"
#import "TYJSONModel.h"

@implementation LPDiscuzResponse

- (BOOL)isValidResponse:(id)response request:(TYHttpRequest *)request error:(NSError *__autoreleasing *)error
{
    if (![super isValidResponse:response request:request error:error]) {
        return NO;
    }
    if (![response isKindOfClass:[NSDictionary class]]) {
        *error = [NSError errorWithDomain:@"response is invalide, is not NSDictionary" code:-1  userInfo:nil];
        return NO;
    }
    self.status = 0;
    return YES;
}

- (id)parseResponse:(id)response request:(TYHttpRequest *)request
{
    self.status = 0;
    id json = [response objectForKey:@"Variables"];
    
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
