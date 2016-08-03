//
//  TYBaseRequest.h
//  TYHttpManagerDemo
//
//  Created by tany on 16/5/23.
//  Copyright © 2016年 tany. All rights reserved.
//

#import "TYRequestProtocol.h"

typedef void (^TYRequestSuccessBlock)(id<TYRequestProtocol> request);
typedef void (^TYRequestFailureBlock)(id<TYRequestProtocol> request,NSError *error);

@protocol TYRequestOverride <NSObject>

// 收到请求数据， 如果error == nil
- (void)requestDidResponse:(id)responseObject error:(NSError *)error;

// 验证请求数据
- (BOOL)validResponseObject:(id)responseObject error:(NSError *__autoreleasing *)error;

// 请求成功
- (void)requestDidFinish;

// 请求失败
- (void)requestDidFailWithError:(NSError* )error;

@end

@interface TYBaseRequest : NSObject<TYRequestProtocol,TYRequestOverride>

#pragma mark - request
@property (nonatomic, weak) NSURLSessionDataTask *dataTask;
@property (nonatomic, assign, readonly) TYRequestState state;
@property (nonatomic, strong, readonly) id responseObject;

@property (nonatomic, weak) id<TYRequestDelegate> delegate; // 请求代理
@property (nonatomic, strong) id<TYRequestDelegate> embedAccesory; // 完成请求代理 后调用 注意strong

#pragma mark - block
@property (nonatomic, copy, readonly) TYRequestSuccessBlock successBlock; // 请求成功block
@property (nonatomic, copy, readonly) TYRequestFailureBlock failureBlock; // 请求失败block

@property (nonatomic, copy) AFProgressBlock progressBlock;// 请求进度block
@property (nonatomic, copy) AFConstructingBodyBlock constructingBodyBlock;// post请求组装body block

#pragma mark - request params
// 请求的URLString 或者 URL path ，baseURL=全局或者本类requestConfigure.baseURL
@property (nonatomic, strong) NSString *URLString;

// 请求方法 默认GET
@property (nonatomic, assign) TYRequestMethod method;

// 请求参数
@property (nonatomic, strong) NSDictionary *parameters;

// 设置请求格式 默认 JSON
@property (nonatomic, assign) TYRequestSerializerType serializerType;

// 请求缓存策略
@property (nonatomic, assign) NSURLRequestCachePolicy cachePolicy;

// 请求的连接超时时间，默认为60秒
@property (nonatomic, assign) NSTimeInterval timeoutInterval;

// 请求设置 默认 使用 全局的requestConfigure
@property (nonatomic, strong) TYRequstConfigure *configuration;

// 在HTTP报头添加的自定义参数
@property (nonatomic, strong) NSDictionary *headerFieldValues;

// 请求
- (void)load;

// 设置回调block
- (void)setRequestSuccessBlock:(TYRequestSuccessBlock)successBlock failureBlock:(TYRequestFailureBlock)failureBlock;

- (void)loadWithSuccessBlock:(TYRequestSuccessBlock)successBlock failureBlock:(TYRequestFailureBlock)failureBlock;

// 取消
- (void)cancle;

@end
