//
//  UITabBarController+TY_AddChildVC.h
//  TYFoundationDemo
//
//  Created by tanyang on 15/12/7.
//  Copyright © 2015年 tanyang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITabBarController (TY_AddChildVC)

/**
 *  添加一个子控制器
 *
 *  @param childVc       子控制器
 *  @param title         标题
 *  @param image         图片
 *  @param selectedImage 选中的图片
 *  @param imageInsets   图片位移
 *  @param titlePosition 标题位移
 *  @param navControllerClass 包装子控制器的导航控制器
 */
- (void)addChildViewController:(UIViewController *)childVc title:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage imageInsets:(UIEdgeInsets)imageInsets titlePosition:(UIOffset)titlePosition navControllerClass:(Class)navControllerClass;

/**
 *  设置自控制器
 *
 *  @param childVc       子控制器
 *  @param title         标题
 *  @param image         图片
 *  @param selectedImage 选中的图片
 *  @param imageInsets   图片位移
 *  @param titlePosition 标题位移
 */
- (void)configureChildViewController:(UIViewController *)childVc title:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage imageInsets:(UIEdgeInsets)imageInsets titlePosition:(UIOffset)titlePosition;

@end
