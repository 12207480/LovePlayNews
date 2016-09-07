//
//  TYModelRequest.h
//  TYHttpManagerDemo
//
//  Created by tany on 16/5/24.
//  Copyright © 2016年 tany. All rights reserved.
//

#import "TYHttpRequest.h"
#import "LPResponseObject.h"
#import "LPRequestURLInfo.h"

@interface LPHttpRequest : TYHttpRequest

@property (nonatomic, strong, readonly) TYResponseObject *responseObject;

@property (nonatomic, strong) NSString *identifier;

- (instancetype)initWithModelClass:(Class)modelClass;

+ (instancetype)requestWithModelClass:(Class)modelClass;

@end
