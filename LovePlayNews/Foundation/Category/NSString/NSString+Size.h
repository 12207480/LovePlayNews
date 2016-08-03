//
//  NSString+TY_Size.h
//  TYFoundationDemo
//
//  Created by tanyang on 15/12/8.
//  Copyright © 2015年 tanyang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSString (TY_Size)

/**
 *  计算文本大小
 *
 *  @param font 字体
 *  @param size 约束大小
 */
- (CGSize)boundingSizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size;

@end
