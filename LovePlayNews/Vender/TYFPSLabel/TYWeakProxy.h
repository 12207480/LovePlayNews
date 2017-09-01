//
//  TYWeakProxy.h
//  PrismDemo
//
//  Created by tany on 2017/8/9.
//  Copyright © 2017年 tany. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TYWeakProxy : NSProxy

@property (nonatomic, weak, readonly,nullable) id target;

- (instancetype)initWithTarget:(id)target;

+ (instancetype)proxyWithTarget:(id)target;

@end

NS_ASSUME_NONNULL_END
