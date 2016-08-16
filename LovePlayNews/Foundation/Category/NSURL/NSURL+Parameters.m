//
//  NSData+Base64.h
//  TYFoundationDemo
//
//  Created by tanyang on 15/12/22.
//  Copyright © 2015年 tanyang. All rights reserved.
//

#import "NSURL+Parameters.h"
#import "NSDictionary+Params.h"
#import <objc/runtime.h>

static void *kURLParametersDictionaryKey;

@implementation NSURL (ty_Parameters)

- (NSURL*)URLByAppendingParametersString:(NSString*)parametersString {
    if (![parametersString length]) {
        return self;
    }
    
    NSString* urlString = [[NSString alloc] initWithFormat:@"%@%@%@", 
        [self absoluteString], 
        [self query]?@"&":@"?", 
        parametersString];
//    NSLog(@"url===%@",urlString);
    return [NSURL URLWithString:urlString];
}

- (NSURL*)URLByAppendingParameters:(NSDictionary*)parameters {
    NSString* parametersString = [parameters parametersString];
    if (!parametersString) {
        return self;
    }
    return [self URLByAppendingParametersString:parametersString];
}


- (void)scanParameters {
    
    if (self.isFileURL) {
        return;
    }
    
    NSScanner *scanner = [NSScanner scannerWithString: self.absoluteString];
    [scanner setCharactersToBeSkipped: [NSCharacterSet characterSetWithCharactersInString:@"&?"] ];
    //skip to ?
    [scanner scanUpToString:@"?" intoString: nil];
    
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    NSString *tmpValue;
    while ([scanner scanUpToString:@"&" intoString:&tmpValue]) {
        
        NSArray *components = [tmpValue componentsSeparatedByString:@"="];
        
        if (components.count >= 2) {
            NSString *key = [components[0] stringByReplacingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
            NSString *value = [components[1] stringByReplacingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
            
            parameters[key] = value;
        }
    }
    
    self.parameters = parameters;
}

- (id)objectForKeyedSubscript:(id)key {
    
    return self.parameters[key];
}


- (NSString *)parameterForKey:(NSString *)key {
    
    return self.parameters[key];
}

- (NSDictionary *)parameters {
    
    NSDictionary *result = objc_getAssociatedObject(self, &kURLParametersDictionaryKey);
    
    if (!result) {
        [self scanParameters];
    }
    
    return objc_getAssociatedObject(self, &kURLParametersDictionaryKey);
}

- (void)setParameters:(NSDictionary *)parameters {
    
    objc_setAssociatedObject(self, &kURLParametersDictionaryKey, parameters, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
}


- (void)dealloc {
    objc_setAssociatedObject(self, &kURLParametersDictionaryKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
