//
//  UITabBarController+TY_AddChildVC.m
//  TYFoundationDemo
//
//  Created by tanyang on 15/12/7.
//  Copyright © 2015年 tanyang. All rights reserved.
//

#import "UITabBarController+addChildVC.h"

@implementation UITabBarController (TY_AddChildVC)

/**
 *  添加一个子控制器
 *  @param childVcClass  子控制器Class
 *  @param title         标题
 *  @param image         图片
 *  @param selectedImage 选中的图片
 *  @param imageInsets   图片位移
 *  @param titlePosition 标题位移
 */
- (void)addChildViewControllerWithClass:(Class)childVcClass title:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage imageInsets:(UIEdgeInsets)imageInsets titlePosition:(UIOffset)titlePosition
{
    [self addChildViewControllerWithClass:childVcClass title:title image:image selectedImage:selectedImage imageInsets:imageInsets titlePosition:titlePosition navControllerClass:nil];
}

/**
 *  添加一个子控制器
 *  @param childVcClass  子控制器Class
 *  @param title         标题
 *  @param image         图片
 *  @param selectedImage 选中的图片
 *  @param imageInsets   图片位移
 *  @param titlePosition 标题位移
 *  @param navControllerClass 包装子控制器的导航控制器
 */
- (void)addChildViewControllerWithClass:(Class)childVcClass title:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage imageInsets:(UIEdgeInsets)imageInsets titlePosition:(UIOffset)titlePosition navControllerClass:(Class)navControllerClass
{
    [self addChildViewController:[[childVcClass alloc]init] title:title image:image selectedImage:selectedImage imageInsets:imageInsets titlePosition:titlePosition navControllerClass:navControllerClass];
}

/**
 *  添加一个子控制器
 *  @param childVc       子控制器
 *  @param title         标题
 *  @param image         图片
 *  @param selectedImage 选中的图片
 *  @param imageInsets   图片位移
 *  @param titlePosition 标题位移
 *  @param navControllerClass 包装子控制器的导航控制器
 */
- (void)addChildViewController:(UIViewController *)childVc title:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage imageInsets:(UIEdgeInsets)imageInsets titlePosition:(UIOffset)titlePosition navControllerClass:(Class)navControllerClass
{
    // 同时设置tabbar和navigationBar的文字
    childVc.title = title;
    childVc.tabBarItem.title = title;
    // 设置子控制器的图片
    childVc.tabBarItem.image = [UIImage imageNamed:image];
    //声明显示图片的原始式样 不要渲染
    childVc.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImage]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    childVc.tabBarItem.imageInsets = imageInsets;
    childVc.tabBarItem.titlePositionAdjustment = titlePosition;
    
    // 给控制器 包装 一个导航控制器
    id nav = nil;
    if (navControllerClass == nil) {
        nav = [[UINavigationController alloc] initWithRootViewController:childVc];
    }else {
        nav = [[navControllerClass alloc] initWithRootViewController:childVc];
    }
    
    // 添加为子控制器
    [self addChildViewController:nav];
}


@end
