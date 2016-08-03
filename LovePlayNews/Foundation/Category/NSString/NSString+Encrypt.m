//
//  NSString+Encrypt.m
//  TYFoundationDemo
//
//  Created by tanyang on 15/12/22.
//  Copyright © 2015年 tanyang. All rights reserved.
//

#import "NSString+Encrypt.h"
#import "NSData+Encrypt.h"
#import "NSData+Base64.h"

@implementation NSString (Encrypt)

-(NSString*)encryptedWithAESUsingKey:(NSString*)key andIV:(NSData*)iv {
    NSData *encrypted = [[self dataUsingEncoding:NSUTF8StringEncoding] encryptedWithAESUsingKey:key andIV:iv];
    NSString *encryptedString = [encrypted base64EncodedString];
    
    return encryptedString;
}

- (NSString*)decryptedWithAESUsingKey:(NSString*)key andIV:(NSData*)iv {
    NSData *decrypted = [[NSData dataWithBase64EncodedString:self] decryptedWithAESUsingKey:key andIV:iv];
    NSString *decryptedString = [[NSString alloc] initWithData:decrypted encoding:NSUTF8StringEncoding];
    
    return decryptedString;
}

@end
