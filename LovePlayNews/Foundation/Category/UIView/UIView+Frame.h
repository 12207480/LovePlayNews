//
//  UIView+TY_Frame.h
//  TYFoundationDemo
//
//  Created by tanyang on 15/12/15.
//  Copyright © 2015年 tanyang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (TY_Frame)

@property(nonatomic, assign) CGPoint origin;// 原点

@property(nonatomic, assign) CGFloat left;//左
@property(nonatomic, assign) CGFloat top;//上

@property(nonatomic, assign) CGFloat right;//右
@property(nonatomic, assign) CGFloat bottom;//下

@property(nonatomic, assign) CGFloat width;//宽度
@property(nonatomic, assign) CGFloat height;//高度

@end
