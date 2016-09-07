//
//  Define_Basic.h
//  TYFoundationDemo
//
//  Created by tanyang on 15/12/23.
//  Copyright © 2015年 tanyang. All rights reserved.
//

#ifndef Define_Basic_h
#define Define_Basic_h

#ifdef __OBJC__
#import <UIKit/UIKit.h>

#endif

#ifdef DEBUG
#   define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#   define DLog(...)
#endif

// 弱引用
#define WEAK_REF(obj)\
__weak typeof(obj) weak_##obj = obj; \

//是否ios7以上系统
#define kIsIOS7Later ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)

// ios8以上
#define kIsIOS8Later ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)

//状态栏预留的高度
#define kHeightInViewForStatus (kIsIOS7Later ? 20 : 0)

//状态条占的高度
#define kHeightForStatus 20

//导航栏高度
#define kNavBarHeight 64

//屏幕高度
#define kScreenHeight CGRectGetHeight([UIScreen mainScreen].bounds)

//屏幕宽度
#define kScreenWidth CGRectGetWidth([UIScreen mainScreen].bounds)

//app高度
#define kApplicationHeight (kIsIOS7Later ? CGRectGetHeight([UIScreen mainScreen].bounds):CGRectGetHeight([[UIScreen mainScreen] applicationFrame]))

//颜色 两种参数
#define RGB_255(r,g,b) [UIColor colorWithRed:(float)r/255.0 green:(float)g/255.0 blue:(float)b/255.0 alpha:1]

#define RGBA_255(r,g,b,a) [UIColor colorWithRed:(float)r/255.0 green:(float)g/255.0 blue:(float)b/255.0 alpha:a]

//当前window
#define kCurrentWindow [[UIApplication sharedApplication].windows firstObject]

//非空的字符串 避免输出null
#define kUnNilStr(str) ((str && ![str isEqual:[NSNull null]])?str:@"")

//app名称
#define kAppName [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"]

//app版本
#define kAppVersion [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]

#endif /* Define_Basic_h */
