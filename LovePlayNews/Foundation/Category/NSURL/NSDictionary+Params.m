//
//  NSData+Base64.h
//  TYFoundationDemo
//
//  Created by tanyang on 15/12/22.
//  Copyright © 2015年 tanyang. All rights reserved.
//

#import "NSDictionary+Params.h"

@implementation NSDictionary (ty_Parameters)

- (NSString*)buildParametersString:(BOOL)ordered {
    NSMutableArray* pairs = [NSMutableArray array];
	
	NSArray* keys = [self allKeys];
    if (ordered) {
        keys = [keys sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
    }
	for (NSString* key in keys) {
		if(![[self objectForKey:key] isKindOfClass:[NSString class]]) {
			continue;
		}
        
        CFStringRef rv = CFURLCreateStringByAddingPercentEscapes(NULL, (__bridge CFStringRef) [self objectForKey:key], NULL, CFSTR("￼=,!$&'()*+;@?\n\"<>#\t :/"), kCFStringEncodingUTF8);
        NSString *copyed = [NSString stringWithString:(__bridge NSString *)rv];
        CFRelease(rv);
		[pairs addObject:[NSString stringWithFormat:@"%@=%@", key, copyed]];
	}
	return [pairs componentsJoinedByString:@"&"];
}

- (NSString*)orderedParametersString {
    return [self buildParametersString:YES];
}

- (NSString*)parametersString {
    return [self buildParametersString:NO];
}

@end
