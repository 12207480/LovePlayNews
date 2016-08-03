//
//  TYChainRequest.h
//  TYHttpManagerDemo
//
//  Created by tany on 16/5/27.
//  Copyright © 2016年 tany. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TYRequestProtocol.h"

@class TYChainRequest;
typedef void (^TYChainRequestSuccessBlock)(TYChainRequest *request);
typedef void (^TYChainRequestFailureBlock)(TYChainRequest *request,NSError *error);

@interface TYChainRequest : NSObject

@property (nonatomic, strong, readonly) NSArray *chainRequstArray;
@property (nonatomic, assign, readonly) NSInteger curRequestIndex;

@property (nonatomic, copy, readonly) TYChainRequestSuccessBlock successBlock; // 请求成功block
@property (nonatomic, copy, readonly) TYChainRequestFailureBlock failureBlock; // 请求失败block

- (void)addRequest:(id<TYRequestProtocol>)request;

- (void)cancleRequest:(id<TYRequestProtocol>)request;

// 设置回调block
- (void)setRequestSuccessBlock:(TYChainRequestSuccessBlock)successBlock failureBlock:(TYChainRequestFailureBlock)failureBlock;

- (void)loadWithSuccessBlock:(TYChainRequestSuccessBlock)successBlock failureBlock:(TYChainRequestFailureBlock)failureBlock;

- (void)load;

- (void)cancle;

@end
