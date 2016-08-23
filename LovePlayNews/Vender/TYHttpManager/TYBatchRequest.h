//
//  TYBatchRequest.h
//  TYHttpManagerDemo
//
//  Created by tany on 16/5/27.
//  Copyright © 2016年 tany. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TYRequestProtocol.h"

@class TYBatchRequest;
typedef void (^TYBatchRequestSuccessBlock)(TYBatchRequest *request);
typedef void (^TYBatchRequestFailureBlock)(TYBatchRequest *request,NSError *error);

@interface TYBatchRequest : NSObject

@property (nonatomic, strong, readonly) NSArray *batchRequstArray;
@property (nonatomic, assign, readonly) NSInteger requestCompleteCount;

@property (nonatomic, copy, readonly) TYBatchRequestSuccessBlock successBlock; // 请求成功block
@property (nonatomic, copy, readonly) TYBatchRequestFailureBlock failureBlock; // 请求失败block

- (void)addRequest:(id<TYRequestProtocol>)request;

- (void)addRequestArray:(NSArray *)requestArray;

- (void)cancleRequest:(id<TYRequestProtocol>)request;

// 设置回调block
- (void)setRequestSuccessBlock:(TYBatchRequestSuccessBlock)successBlock failureBlock:(TYBatchRequestFailureBlock)failureBlock;

- (void)loadWithSuccessBlock:(TYBatchRequestSuccessBlock)successBlock failureBlock:(TYBatchRequestFailureBlock)failureBlock;

- (void)load;

- (void)cancle;

@end
