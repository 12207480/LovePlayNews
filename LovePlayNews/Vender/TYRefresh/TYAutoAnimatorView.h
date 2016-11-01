//
//  TYAutoAnimatorView.h
//  TYRefreshDemo
//
//  Created by tany on 16/10/25.
//  Copyright © 2016年 tany. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TYRefreshView.h"

@interface TYAutoAnimatorView : UIView<TYRefreshAnimator>

// UI
@property (nonatomic, weak, readonly) UILabel *titleLabel;

@property (nonatomic, weak, readonly) UIImageView *imageView;

@property (nonatomic, weak, readonly) UIActivityIndicatorView *indicatorView;

// Data
@property (nonatomic, assign) BOOL titleLabelHidden;

@property (nonatomic, assign) CGFloat imageCenterOffsetX;

@property (nonatomic, assign) CGFloat titleLabelLeftEdging;

@property (nonatomic, assign) CGFloat loadingAnimationDuration;

- (instancetype)initWithHeight:(CGFloat)height;

- (void)setTitle:(NSString *)title forState:(TYRefreshState)state;

- (void)setLoadingImages:(NSArray *)loadingImages;

@end
