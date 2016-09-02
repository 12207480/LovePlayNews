//
//  TYRequestProtocol.h
//  TYHttpManagerDemo
//
//  Created by tany on 16/5/20.
//  Copyright © 2016年 tany. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TYRequstConfigure.h"

typedef NS_ENUM(NSUInteger, TYRequestMethod) {
    TYRequestMethodGet,
    TYRequestMethodPost,
    TYRequestMethodHead,
    TYRequestMethodPut,
    TYRequestMethodDelete,
    TYRequestMethodPatch
};

typedef NS_ENUM(NSInteger , TYRequestSerializerType) {
    TYRequestSerializerTypeHTTP,
    TYRequestSerializerTypeJSON,
    TYRequestSerializerTypeString
};

typedef NS_ENUM(NSUInteger, TYRequestState) {
    TYRequestStateReady,
    TYRequestStateLoading,
    TYRequestStateCancle,
    TYRequestStateFinish,
    TYRequestStateError
};

@protocol AFMultipartFormData; // need import afnetwork
typedef void(^AFProgressBlock)(NSProgress * progress);
typedef void(^AFConstructingBodyBlock)(id <AFMultipartFormData> formData);


@protocol TYRequestProtocol;
@protocol TYRequestDelegate <NSObject>

@optional

- (void)requestDidFinish:(id<TYRequestProtocol>)request;

- (void)requestDidFail:(id<TYRequestProtocol>)request error:(NSError *)error;

@end


@protocol TYRequestProtocol <NSObject>

@property (nonatomic, weak) NSURLSessionTask *dataTask;

@property (nonatomic, assign, readonly) TYRequestState state;
@property (nonatomic, strong, readonly) id responseObject;

@property (nonatomic, weak) id<TYRequestDelegate> delegate; // 请求代理
@property (nonatomic, strong) id<TYRequestDelegate> embedAccesory; // 嵌入请求代理 注意strong

// baseURL 如果为空，则为全局或者本类requestConfigure.baseURL
- (NSString *)baseURL;

// 请求的URLString,或者 URL path
- (NSString *)URLString;

// 请求参数
- (NSDictionary *)parameters;

// 请求的方法 默认get
- (TYRequestMethod)method;

// request configure
- (TYRequstConfigure *)configuration;

// 在HTTP报头添加的自定义参数
- (NSDictionary *)headerFieldValues;

// 请求的连接超时时间，默认为60秒
- (NSTimeInterval)timeoutInterval;

// 缓存策略
- (NSURLRequestCachePolicy) cachePolicy;

// 设置请求格式 默认 JSON
- (TYRequestSerializerType)serializerType;

// 返回进度block
- (AFProgressBlock)progressBlock;

// 返回post组装body block
- (AFConstructingBodyBlock)constructingBodyBlock;

// 处理请求数据， 如果error == nil ,请求成功
- (void)requestDidResponse:(id)responseObject error:(NSError *)error;

// 请求
- (void)load;

// 取消
- (void)cancle;

@end
