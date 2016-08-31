//
//  LPCustomResponse.m
//  LovePlayNews
//
//  Created by tany on 16/8/23.
//  Copyright © 2016年 tany. All rights reserved.
//

#import "LPCustomResponse.h"
#import "TYJSONModel.h"

@implementation LPCustomResponse

- (id)parseResponse:(id)response request:(TYHttpRequest *)request
{
    self.status = [[response objectForKey:@"code"] integerValue];
    
    if (self.modelClass) {
        if ([response isKindOfClass:[NSDictionary class]]) {
            self.data = [[self modelClass] ty_ModelWithDictonary:response];
        }else if ([response isKindOfClass:[NSArray class]]) {
            self.data = [[self modelClass] ty_ModelArrayWithDictionaryArray:response];
        }
    }else {
        self.data = response;
    }
    return self;
}

@end
