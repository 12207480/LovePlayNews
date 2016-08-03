//
//  UIImage+TY_Snap.h
//  TYFoundationDemo
//
//  Created by tanyang on 15/12/8.
//  Copyright © 2015年 tanyang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (TY_Snap)

/**
 *  view截屏(快照)
 *
 *  @param view 截屏的view
 */
+ (UIImage *)snapshotWithView:(UIView *)view;

/**
 *  view截屏(快照)
 *
 *  @param view     截屏的view
 *  @param snapSize 截屏大小
 */
+ (UIImage *)snapshotWithView:(UIView *)view size:(CGSize)snapSize;

@end
