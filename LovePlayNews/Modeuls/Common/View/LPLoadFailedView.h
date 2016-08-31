//
//  LPLoadFailedView.h
//  LovePlayNews
//
//  Created by tany on 16/8/30.
//  Copyright © 2016年 tany. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LPLoadFailedView : UIView

@property (weak, nonatomic) IBOutlet UIButton *retryBtn;
@property (weak, nonatomic) IBOutlet UILabel *failedTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *retryTitleLabel;

@property (nonatomic, assign) UIEdgeInsets edgeInset;

@property (nonatomic, copy) void (^retryHandle)(void);

+ (void)showLoadFailedInView:(UIView *)view;

+ (void)showLoadFailedInView:(UIView *)view retryHandle: (void (^)(void))retryHandle;

+ (void)showLoadFailedInView:(UIView *)view edgeInset:(UIEdgeInsets)edgeInset;

+ (void)showLoadFailedInView:(UIView *)view edgeInset:(UIEdgeInsets)edgeInset retryHandle: (void (^)(void))retryHandle;

+ (void)hideLoadFailedForView:(UIView *)view;

+ (LPLoadFailedView *)loadFailedForView:(UIView *)view;

- (void)showInView:(UIView *)view;

- (void)hide;

@end
