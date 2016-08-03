//
//  UIImage+TY_Color.h
//  ITHome
//
//  Created by tanyang on 15/12/7.
//  Copyright © 2015年 tanyang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (TY_Color)

/**
 *  用color生成image
 *
 *  @param color 颜色
 */
+ (UIImage *)imageWithColor:(UIColor *)color;

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;
/**
 *  改变image透明度
 *
 *  @param alpha 透明度
 */
- (UIImage *)imageWithAlpha:(CGFloat)alpha;

@end
