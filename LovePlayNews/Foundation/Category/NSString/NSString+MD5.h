//
//  NSString+TY_MD5.h
//  TYFoundationDemo
//
//  Created by tanyang on 15/12/23.
//  Copyright © 2015年 tanyang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (TY_MD5)

+ (NSString *)md5:(NSString *)str;

- (NSString *)md5String;

@end
