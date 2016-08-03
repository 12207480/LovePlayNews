//
//  UIImage+TY_Clip.h
//  ITHome
//
//  Created by tanyang on 15/12/7.
//  Copyright © 2015年 tanyang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (TY_Clip)

/**
 *  生成相应圆角image
 *
 *  @param radius 圆角度
 */
- (UIImage *)imageWithCornerRadius:(CGFloat)radius;

/**
 *  根据遮罩图生成相应image
 *
 *  @param maskImage 遮罩图
 */
- (UIImage *)imageWithMask:(UIImage *)maskImage;

@end
