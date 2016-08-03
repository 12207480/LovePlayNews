//
//  NSData+Base64.h
//  TYFoundationDemo
//
//  Created by tanyang on 15/12/22.
//  Copyright © 2015年 tanyang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (Base64)

+ (NSData *)dataWithBase64EncodedString:(NSString *)string;
- (NSString *)base64EncodedStringWithWrapWidth:(NSUInteger)wrapWidth;
- (NSString *)base64EncodedString;

@end
