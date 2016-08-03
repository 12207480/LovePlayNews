//
//  UIView+TY_Nib.h
//  ITHome
//
//  Created by tanyang on 15/12/7.
//  Copyright © 2015年 tanyang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (TY_Nib)

/**
 *  加载nib
 */
+ (UINib *)loadNib;

/**
 *  加载nib
 *
 *  @param nibName nib名字
 */
+ (UINib *)loadNibNamed:(NSString*)nibName;

/**
 *  加载nib
 *
 *  @param nibName nib名字
 *  @param bundle  nib文件包（目录）
 */
+ (UINib *)loadNibNamed:(NSString*)nibName bundle:(NSBundle *)bundle;


/**
 *  加载nib生成view
 */
+ (instancetype)loadInstanceFromNib;

/**
 *  加载nib生成view
 *
 *  @param nibName nib名字
 */
+ (instancetype)loadInstanceFromNibWithName:(NSString *)nibName;

/**
 *   加载nib生成view
 *
 *  @param nibName nib名字
 *  @param owner   nib文件的File's Owner
 */
+ (instancetype)loadInstanceFromNibWithName:(NSString *)nibName owner:(id)owner;

/**
 *  加载nib生成view
 *
 *  @param nibName nib名字
 *  @param owner   nib文件的File's Owner
 *  @param bundle  nib文件包（目录）
 */
+ (instancetype)loadInstanceFromNibWithName:(NSString *)nibName owner:(id)owner bundle:(NSBundle *)bundle;

@end
