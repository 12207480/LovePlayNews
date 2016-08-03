//
//  NSData+Encrypt.h
//  TYFoundationDemo
//
//  Created by tanyang on 15/12/22.
//  Copyright © 2015年 tanyang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (Encrypt)

/**
 *  利用AES加密数据
 *
 *  @param key key
 *  @param iv  iv description
 *
 *  @return data
 */
- (NSData *)encryptedWithAESUsingKey:(NSString*)key andIV:(NSData*)iv;
/**
 *  @brief  利用AES解密据
 *
 *  @param key key
 *  @param iv  iv
 *
 *  @return 解密后数据
 */
- (NSData *)decryptedWithAESUsingKey:(NSString*)key andIV:(NSData*)iv;

@end
