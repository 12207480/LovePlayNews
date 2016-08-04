//
//  TYResponseObject.h
//  TYHttpManagerDemo
//
//  Created by tany on 16/5/24.
//  Copyright © 2016年 tany. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TYHttpRequest.h"

typedef NS_ENUM(NSInteger, TYStauteCode) {
    TYStauteSuccessCode = 0,
};

@interface TYResponseObject : NSObject<TYHttpResponseParser>

@property (nonatomic, strong) NSString *msg;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, strong) id data;// data数据
//@property (nonatomic, strong) id json; // josn数据
//@property (nonatomic, assign) NSUInteger pgIndex;//第几页
//@property (nonatomic, assign) NSUInteger pgSize;
//@property (nonatomic, assign) NSUInteger count;//总消息条数

// 初始化方法
- (instancetype)initWithModelClass:(Class)modelClass;

// 验证
- (BOOL)isValidResponse:(id)response request:(TYHttpRequest *)request error:(NSError *__autoreleasing *)error;

// 解析 返回model
- (id)parseResponse:(id)response request:(TYHttpRequest *)request;

@end
