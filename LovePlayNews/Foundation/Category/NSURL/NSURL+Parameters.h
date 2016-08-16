//
//  NSData+Base64.h
//  TYFoundationDemo
//
//  Created by tanyang on 15/12/22.
//  Copyright © 2015年 tanyang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSURL (ty_Parameters)

@property (nonatomic, strong) NSDictionary *parameters;

- (NSURL*)URLByAppendingParametersString:(NSString*)parametersString;
- (NSURL*)URLByAppendingParameters:(NSDictionary*)parameters;


- (NSString *)parameterForKey:(NSString *)key;
- (id)objectForKeyedSubscript:(id)key NS_AVAILABLE(10_8, 6_0);
@end
