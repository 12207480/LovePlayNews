//
//  TYChainRequest.m
//  TYHttpManagerDemo
//
//  Created by tany on 16/5/27.
//  Copyright © 2016年 tany. All rights reserved.
//

#import "TYChainRequest.h"

@interface TYChainRequest ()<TYRequestDelegate>
@property (nonatomic, strong) NSMutableArray *chainRequstArray;
@property (nonatomic, assign) NSInteger curRequestIndex;
@property (nonatomic, assign) BOOL isLoading;
@end

@implementation TYChainRequest

- (instancetype)init
{
    if (self = [super init]) {
        _chainRequstArray = [NSMutableArray array];
    }
    return self;
}

- (void)addRequest:(id<TYRequestProtocol>)request
{
    if (_isLoading) {
        NSLog(@"TYChainRequest is Running,can't add request");
        return;
    }
    request.embedAccesory = self;
    [_chainRequstArray addObject:request];
}

- (void)cancleRequest:(id<TYRequestProtocol>)request
{
    request.embedAccesory = nil;
    [request  cancle];
    [_chainRequstArray removeObject:request];
}

- (void)load
{
    if (_isLoading ||_chainRequstArray.count == 0) {
        return;
    }

    _isLoading = YES;
    [self loadNextChainRequestWithCurIndex:-1];
}

- (void)setRequestSuccessBlock:(TYChainRequestSuccessBlock)successBlock failureBlock:(TYChainRequestFailureBlock)failureBlock
{
    _successBlock = successBlock;
    _failureBlock = failureBlock;
    
}

- (void)loadWithSuccessBlock:(TYChainRequestSuccessBlock)successBlock failureBlock:(TYChainRequestFailureBlock)failureBlock
{
    [self setRequestSuccessBlock:successBlock failureBlock:failureBlock];
    
    [self load];
}

- (void)cancle
{
    for (id<TYRequestProtocol> request in _chainRequstArray) {
        request.embedAccesory = nil;
    }
    
    if (_curRequestIndex >= 0 && _curRequestIndex < _chainRequstArray.count) {
        id<TYRequestProtocol> request = _chainRequstArray[_curRequestIndex];
        [request cancle];
    }
    
    [_chainRequstArray removeAllObjects];
    _curRequestIndex = 0;
    _isLoading = NO;
}

- (void)loadNextChainRequestWithCurIndex:(NSInteger)index
{
    NSInteger count = _chainRequstArray.count;
    if (index >= -1 && index < count - 1) {
        _curRequestIndex = index + 1;
        id<TYRequestProtocol> request = _chainRequstArray[_curRequestIndex];
        [request load];
    }else {
        if (_successBlock) {
            _successBlock(self);
        }
        [_chainRequstArray removeAllObjects];
        _isLoading = NO;
    }
}

#pragma mark - delegate

- (void)requestDidFinish:(id<TYRequestProtocol>)request
{
    NSInteger index = [_chainRequstArray indexOfObject:request];
    if (index != NSNotFound) {
        [self loadNextChainRequestWithCurIndex:index];
    }
}

- (void)requestDidFail:(id<TYRequestProtocol>)request error:(NSError *)error
{
    if (_failureBlock) {
        _failureBlock(self,error);
    }
    [_chainRequstArray removeAllObjects];
    _isLoading = NO;
    
}

- (void)dealloc
{
    _successBlock = nil;
    _failureBlock = nil;
}

@end
