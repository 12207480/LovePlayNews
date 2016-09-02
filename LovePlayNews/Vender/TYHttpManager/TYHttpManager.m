//
//  TYHttpManager.m
//  TYHttpManagerDemo
//
//  Created by tany on 16/5/23.
//  Copyright © 2016年 tany. All rights reserved.
//

#import "TYHttpManager.h"
#import "AFNetworking.h"

@implementation TYHttpManager

#pragma mark - init

+ (TYHttpManager *)sharedInstance {
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

+ (dispatch_queue_t)completeQueue {
    static dispatch_queue_t completeQueue = NULL;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        completeQueue = dispatch_queue_create("com.TYHttpManager.completeQueue", DISPATCH_QUEUE_SERIAL);
        dispatch_set_target_queue(completeQueue, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0));
    });
    return completeQueue;
}

- (instancetype)init
{
    if (self = [super init]) {
        _requestConfiguration = [TYRequstConfigure sharedInstance];
    }
    return self;
}

#pragma maek - add request

- (void)addRequest:(id<TYRequestProtocol>)request
{
    AFHTTPSessionManager *manager = [self defaultSessionManagerWithRequest:request];
    
    [self configureSessionManager:manager request:request];
    
    [self loadRequest:request sessionManager:manager];
}

- (void)cancleRequest:(id<TYRequestProtocol>)request
{
    [request cancle];
}

#pragma mark - configure http manager

- (AFHTTPSessionManager *)defaultSessionManagerWithRequest:(id<TYRequestProtocol>)request
{
    TYRequstConfigure *requestConfiguration = [request configuration];
    if (requestConfiguration == nil) {
        requestConfiguration = self.requestConfiguration;
    }
    
    AFHTTPSessionManager *manager = nil;
    if (requestConfiguration.sessionConfiguration) {
        manager = [[AFHTTPSessionManager alloc]initWithBaseURL:[NSURL URLWithString:requestConfiguration.baseURL] sessionConfiguration:requestConfiguration.sessionConfiguration];
    }else {
        manager = [AFHTTPSessionManager manager];
    }
    manager.completionQueue = [[self class] completeQueue];
    return manager;
}

- (void)configureSessionManager:(AFHTTPSessionManager *)manager request:(id<TYRequestProtocol>)request
{
    if ([request serializerType] == TYRequestSerializerTypeJSON) {
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
    }else if ([request serializerType] == TYRequestSerializerTypeString) {
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        manager.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
    }
    
    NSDictionary *headerFieldValue = [request headerFieldValues];
    if (headerFieldValue) {
        [headerFieldValue enumerateKeysAndObjectsUsingBlock:^(id key, id value, BOOL * stop) {
            if ([key isKindOfClass:[NSString class]] && [value isKindOfClass:[NSString class]]) {
                [manager.requestSerializer setValue:value forHTTPHeaderField:key];
            }
        }];
    }
    
    manager.requestSerializer.cachePolicy = [request cachePolicy];
    manager.requestSerializer.timeoutInterval = [request timeoutInterval];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/plain", @"text/javascript", @"text/json", @"text/html", nil];
}

- (NSString *)buildRequstURL:(id<TYRequestProtocol>)request
{
    NSString *URLPath = [request URLString];
    if ([URLPath hasPrefix:@"http:"] ) {
        return URLPath;
    }
    
    NSString *baseURL = request.baseURL.length > 0 ? request.baseURL : (request.configuration ? request.configuration.baseURL : [TYRequstConfigure sharedInstance].baseURL);
    
    return [NSString stringWithFormat:@"%@%@",baseURL?baseURL:@"",URLPath];
}

- (void)loadRequest:(id<TYRequestProtocol>)request sessionManager:(AFHTTPSessionManager *)manager
{
    NSString *URLString = [self buildRequstURL:request];
    NSDictionary *parameters = [request parameters];
    
    TYRequestMethod requestMethod = [request method];
    AFProgressBlock progressBlock = [request progressBlock];
    
    if (requestMethod == TYRequestMethodGet) {
        
        request.dataTask = [manager GET:URLString parameters:parameters progress:progressBlock success:^(NSURLSessionDataTask * task, id responseObject) {
            [request requestDidResponse:responseObject error:nil];
        } failure:^(NSURLSessionDataTask * task, NSError * error) {
            [request requestDidResponse:nil error:error];
        }];
    }else if (requestMethod == TYRequestMethodPost) {
        
        AFConstructingBodyBlock constructingBodyBlock = [request constructingBodyBlock];
        if (constructingBodyBlock) {
            request.dataTask =  [manager POST:URLString parameters:parameters constructingBodyWithBlock:constructingBodyBlock progress:progressBlock  success:^(NSURLSessionDataTask * task, id responseObject) {
                [request requestDidResponse:responseObject error:nil];
            } failure:^(NSURLSessionDataTask * task, NSError * error) {
                [request requestDidResponse:nil error:error];
            }];
        }else {
            request.dataTask =  [manager POST:URLString parameters:parameters progress:progressBlock  success:^(NSURLSessionDataTask * task, id responseObject) {
                [request requestDidResponse:responseObject error:nil];
            } failure:^(NSURLSessionDataTask * task, NSError * error) {
                [request requestDidResponse:nil error:error];
            }];
        }
    }else if (requestMethod == TYRequestMethodHead) {
        
        request.dataTask = [manager HEAD:URLString parameters:parameters success:^(NSURLSessionDataTask * task) {
            [request requestDidResponse:nil error:nil];
        } failure:^(NSURLSessionDataTask * task, NSError * error) {
            [request requestDidResponse:nil error:error];
        }];
    }else if (requestMethod == TYRequestMethodPut) {
        
        request.dataTask = [manager PUT:URLString parameters:parameters success:^(NSURLSessionDataTask * task, id responseObject) {
            [request requestDidResponse:responseObject error:nil];
        } failure:^(NSURLSessionDataTask * task, NSError * error) {
            [request requestDidResponse:nil error:error];
        }];
    }else if (requestMethod == TYRequestMethodPatch) {
        
        request.dataTask = [manager PATCH:URLString parameters:parameters success:^(NSURLSessionDataTask * task, id responseObject) {
            [request requestDidResponse:responseObject error:nil];
        } failure:^(NSURLSessionDataTask * task, NSError * error) {
            [request requestDidResponse:nil error:error];
        }];
    }
}

@end
