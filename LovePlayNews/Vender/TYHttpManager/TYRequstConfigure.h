//
//  TYRequstConfigure.h
//  TYHttpManagerDemo
//
//  Created by tany on 16/5/23.
//  Copyright © 2016年 tany. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TYRequstConfigure : NSObject

@property (nonatomic, strong) NSString *baseURL;

// session configure
@property (nonatomic, strong) NSURLSessionConfiguration *sessionConfiguration;

+ (TYRequstConfigure *)sharedInstance;

@end
