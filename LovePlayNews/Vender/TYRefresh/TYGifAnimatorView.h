//
//  TYGifAnimatorView.h
//  TYRefreshDemo
//
//  Created by tany on 16/10/13.
//  Copyright © 2016年 tany. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TYRefreshView.h"

@interface TYGifAnimatorView : UIView<TYRefreshAnimator>

// UI
@property (nonatomic, weak, readonly) UILabel *titleLabel;

@property (nonatomic, weak, readonly) UILabel *messageLabel;

@property (nonatomic, weak, readonly) UIImageView *imageView;

// Data
@property (nonatomic, assign) BOOL titleLabelHidden;

@property (nonatomic, assign) CGFloat animationDuration;

@property (nonatomic, assign) CGFloat imageCenterOffsetX;

@property (nonatomic, assign) CGFloat titleLabelLeftEdging;


- (instancetype)initWithHeight:(CGFloat)height;

- (void)setTitle:(NSString *)title forState:(TYRefreshState)state;

- (void)setGifImages:(NSArray *)gifImages forState:(TYRefreshState)state;

@end
