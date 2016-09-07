//
//  TYHttpRequest.h
//  TYHttpManagerDemo
//
//  Created by tany on 16/5/23.
//  Copyright © 2016年 tany. All rights reserved.
//

#import "TYBaseRequest.h"
#import "TYBatchRequest.h"
#import "TYChainRequest.h"

@class TYHttpRequest;
// 请求数据解析 protocol
@protocol TYHttpResponseParser <NSObject>

- (BOOL)isValidResponse:(id)response request:(TYHttpRequest *)request error:(NSError *__autoreleasing *)error;

- (id)parseResponse:(id)response request:(TYHttpRequest *)request;

@end

// 请求数据缓存 protocol
@protocol TYHttpResponseCache <NSObject>

- (void)setObject:(id <NSCoding>)object forKey:(NSString *)key;

- (id <NSCoding>)objectForKey:(NSString *)key overdueDate:(NSDate *)overdueDate;

@end

@interface TYHttpRequest : TYBaseRequest

@property (nonatomic, assign, readonly) BOOL responseFromCache; // response是否来自缓存

// 是否请求缓存的response 默认NO
@property (nonatomic, assign) BOOL requestFromCache;

// 是否缓存response ，有效的response才会缓存 默认NO
@property (nonatomic, assign) BOOL cacheResponse;

// 缓存时间 默认7天
@property (nonatomic, assign) NSInteger cacheTimeInSeconds;

// 缓存忽略的某些Paramters的key
@property (nonatomic, strong) NSArray *cacheIgnoreParamtersKeys;

@property (nonatomic, strong) id<TYHttpResponseParser> responseParser; // 数据解析
@property (nonatomic, strong) id<TYHttpResponseCache> responseCache; // 数据缓存

@end
