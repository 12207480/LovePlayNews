//
//  TYAnimatorView.h
//  TYRefreshDemo
//
//  Created by tany on 16/10/12.
//  Copyright © 2016年 tany. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TYRefreshView.h"

@interface TYAnimatorView : UIView<TYRefreshAnimator>

// UI
@property (nonatomic, weak, readonly) UILabel *titleLabel;

@property (nonatomic, weak, readonly) UILabel *messageLabel;

@property (nonatomic, weak, readonly) UIImageView *imageView;

@property (nonatomic, weak, readonly) UIActivityIndicatorView *indicatorView;

- (instancetype)initWithHeight:(CGFloat)height;

- (void)setTitle:(NSString *)title forState:(TYRefreshState)state;

@end
