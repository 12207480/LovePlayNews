//
//  TYBaseRequest.m
//  TYHttpManagerDemo
//
//  Created by tany on 16/5/23.
//  Copyright © 2016年 tany. All rights reserved.
//

#import "TYBaseRequest.h"
#import "TYHttpManager.h"

@interface TYBaseRequest ()
@property (nonatomic, copy) TYRequestSuccessBlock successBlock;
@property (nonatomic, copy) TYRequestFailureBlock failureBlock;

@property (nonatomic, assign) TYRequestState state;
@property (nonatomic, strong) id responseObject;
@end

@implementation TYBaseRequest

-(instancetype)init
{
    if (self = [super init]) {
        _method = TYRequestMethodGet;
        _serializerType = TYRequestSerializerTypeJSON;
        _timeoutInterval = 60;
    }
    return self;
}

#pragma mark - load request

// 请求
- (void)load
{
    [[TYHttpManager sharedInstance] addRequest:self];
    _state = TYRequestStateLoading;
}

// 取消
- (void)cancle
{
    [_dataTask cancel];
    [self clearRequestBlock];
    _delegate = nil;
    _state = TYRequestStateCancle;
}

- (void)setRequestSuccessBlock:(TYRequestSuccessBlock)successBlock failureBlock:(TYRequestFailureBlock)failureBlock
{
    _successBlock = successBlock;
    _failureBlock = failureBlock;
    
}

- (void)loadWithSuccessBlock:(TYRequestSuccessBlock)successBlock failureBlock:(TYRequestFailureBlock)failureBlock
{
    [self setRequestSuccessBlock:successBlock failureBlock:failureBlock];
    
    [self load];
}

#pragma mark - call delegate , block

// 收到数据
- (void)requestDidResponse:(id)responseObject error:(NSError *)error
{
    if (error) {
        [self requestDidFailWithError:error];
    }else {
        if ([self validResponseObject:responseObject error:&error]){
            [self requestDidFinish];
        }else{
            [self requestDidFailWithError:error];
        }
    }
}

// 验证数据
- (BOOL)validResponseObject:(id)responseObject error:(NSError *__autoreleasing *)error
{
    _responseObject = responseObject;
    return _responseObject ? YES : NO;
}

// 请求成功
- (void)requestDidFinish
{
    _state = TYRequestStateFinish;
    if ([_delegate respondsToSelector:@selector(requestDidFinish:)]) {
        [_delegate requestDidFinish:self];
    }
    
    if (_successBlock) {
        _successBlock(self);
    }
    
    if (_embedAccesory && [_embedAccesory respondsToSelector:@selector(requestDidFinish:)]) {
        [_embedAccesory requestDidFinish:self];
    }

}

// 请求失败
- (void)requestDidFailWithError:(NSError* )error
{
    _state = TYRequestStateError;
    if ([_delegate respondsToSelector:@selector(requestDidFail:error:)]) {
        [_delegate requestDidFail:self error:error];
    }
    
    if (_failureBlock) {
        _failureBlock(self,error);
    }
    
    if (_embedAccesory && [_embedAccesory respondsToSelector:@selector(requestDidFail:error:)]) {
        [_delegate requestDidFail:self error:error];
    }
}

// 清除block引用
- (void)clearRequestBlock
{
    _successBlock = nil;
    _failureBlock = nil;
    _progressBlock = nil;
    _constructingBodyBlock = nil;
}

- (void)dealloc
{
    [self clearRequestBlock];
    _delegate = nil;
}

@end
