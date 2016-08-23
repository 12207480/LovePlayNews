//
//  TYHttpManager.h
//  TYHttpManagerDemo
//
//  Created by tany on 16/5/23.
//  Copyright © 2016年 tany. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TYRequestProtocol.h"

@interface TYHttpManager : NSObject

@property (nonatomic, strong) TYRequstConfigure *requestConfiguration;// session configure

+ (TYHttpManager *)sharedInstance;

- (void)addRequest:(id<TYRequestProtocol>)request;

- (void)cancleRequest:(id<TYRequestProtocol>)request;

- (NSString *)buildRequstURL:(id<TYRequestProtocol>)request;

@end
