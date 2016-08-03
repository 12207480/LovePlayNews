//
//  UIImage+TY_Size.h
//  TYFoundationDemo
//
//  Created by tanyang on 15/12/9.
//  Copyright © 2015年 tanyang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (TY_Size)

/**
 *  生成按0.5，0.5位置拉伸image
 *
 *  @param name 图片名
 *
 *  @return 支持拉伸后的image
 */
+ (UIImage *)resizedImageWithName:(NSString *)name;

/**
 *  生成按left，top位置拉伸image
 *
 *  @param name 图片名
 *  @param left 左边比例
 *  @param top  上边比例
 *
 *  @return 支持拉伸后的image
 */
+ (UIImage *)resizedImageWithName:(NSString *)name left:(CGFloat)left top:(CGFloat)top;

- (UIImage *)imageCroppedToRect:(CGRect)rect;

- (UIImage *)imageScaledToSize:(CGSize)size;

- (UIImage *)imageScaledToFitSize:(CGSize)size;

- (UIImage *)imageScaledToFillSize:(CGSize)size;

- (UIImage *)imageCroppedAndScaledToSize:(CGSize)size
                             contentMode:(UIViewContentMode)contentMode
                                padToFit:(BOOL)padToFit;

@end
