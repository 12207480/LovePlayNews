//
//  LPLoadingView.h
//  LovePlayNews
//
//  Created by tany on 16/8/24.
//  Copyright © 2016年 tany. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LPLoadingView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;

@property (nonatomic, assign) UIEdgeInsets edgeInset;

// 便利方法

+ (void)showLoadingInView:(UIView *)view;

+ (void)showLoadingInView:(UIView *)view edgeInset:(UIEdgeInsets)edgeInset;

+ (void)hideLoadingForView:(UIView *)view;

+ (void)hideAllLoadingForView:(UIView *)view;

+ (LPLoadingView *)loadingForView:(UIView *)view;

// 实例方法
+ (instancetype)loadViewFromNib;

- (void)showInView:(UIView *)view;

- (void)hide;

@end
