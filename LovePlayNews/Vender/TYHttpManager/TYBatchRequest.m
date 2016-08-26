//
//  TYBatchRequest.m
//  TYHttpManagerDemo
//
//  Created by tany on 16/5/27.
//  Copyright © 2016年 tany. All rights reserved.
//

#import "TYBatchRequest.h"

@interface TYBatchRequest ()<TYRequestDelegate>
@property (nonatomic, strong) NSMutableArray *batchRequstArray;
@property (nonatomic, assign) NSInteger requestCompleteCount;
@property (nonatomic, assign) BOOL isLoading;
@end

@implementation TYBatchRequest

- (instancetype)init
{
    if (self = [super init]) {
        _batchRequstArray = [NSMutableArray array];
    }
    return self;
}

- (void)addRequest:(id<TYRequestProtocol>)request
{
    if (_isLoading) {
        NSLog(@"TYBatchRequest is Running,can't add request");
        return;
    }
    request.embedAccesory = self;
    [_batchRequstArray addObject:request];
}

- (void)addRequestArray:(NSArray *)requestArray
{
    for (id<TYRequestProtocol> request in requestArray) {
        if ([request conformsToProtocol:@protocol(TYRequestProtocol) ]) {
            [self addRequest:request];
        }
    }
}

- (void)cancleRequest:(id<TYRequestProtocol>)request
{
    request.embedAccesory = nil;
    [request  cancle];
    [_batchRequstArray removeObject:request];
}

- (void)setRequestSuccessBlock:(TYBatchRequestSuccessBlock)successBlock failureBlock:(TYBatchRequestFailureBlock)failureBlock
{
    _successBlock = successBlock;
    _failureBlock = failureBlock;
    
}

- (void)loadWithSuccessBlock:(TYBatchRequestSuccessBlock)successBlock failureBlock:(TYBatchRequestFailureBlock)failureBlock
{
    [self setRequestSuccessBlock:successBlock failureBlock:failureBlock];
    
    [self load];
}

- (void)load{
    if (_isLoading ||_batchRequstArray.count == 0) {
        return;
    }
    _isLoading = YES;
    _requestCompleteCount = 0;
    for (id<TYRequestProtocol> request in _batchRequstArray) {
        [request load];
    }
}

- (void)cancle
{
    for (id<TYRequestProtocol> request in _batchRequstArray) {
        request.embedAccesory = nil;
        [request cancle];
    }
    [_batchRequstArray removeAllObjects];
    _requestCompleteCount = 0;
    _isLoading = NO;
}

#pragma mark - delegate

- (void)requestDidFinish:(id<TYRequestProtocol>)request
{
    NSInteger index = [_batchRequstArray indexOfObject:request];
    if (index != NSNotFound) {
        ++_requestCompleteCount;
    }
    
    if (_requestCompleteCount == _batchRequstArray.count) {
        if (_successBlock) {
            _successBlock(self);
        }
        [_batchRequstArray removeAllObjects];
        _isLoading = NO;
    }
}

- (void)requestDidFail:(id<TYRequestProtocol>)request error:(NSError *)error
{
    if (_failureBlock) {
        _failureBlock(self,error);
    }
    [_batchRequstArray removeAllObjects];
    _isLoading = NO;
    
}

- (void)clearBlocks
{
    _successBlock = nil;
    _failureBlock = nil;
}

- (void)dealloc
{
    [self clearBlocks];
}


@end
