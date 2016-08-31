//
//  LPLoadingView.m
//  LovePlayNews
//
//  Created by tany on 16/8/24.
//  Copyright © 2016年 tany. All rights reserved.
//

#import "LPLoadingView.h"

static NSArray *s_refreshingImages = nil;

@implementation LPLoadingView

+ (instancetype)loadViewFromNib
{
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
    return [nib objectAtIndex:0];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    _edgeInset = UIEdgeInsetsZero;
    
    [self addAnimalImages];
}

- (NSArray *)refreshingImages
{
    if (!s_refreshingImages) {
        NSMutableArray *refreshingImages  = [NSMutableArray array];
        for (int i = 1; i < 7; ++i) {
            UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"loading_step%d",i]];
            [refreshingImages addObject:image];
        }
        s_refreshingImages = [refreshingImages copy];
    }
    return s_refreshingImages;
}

- (void)addAnimalImages
{
    self.imageView.animationDuration = 1.5;
    self.imageView.animationImages = [self refreshingImages];
}

#pragma mark - 便利方法

+ (void)showLoadingInView:(UIView *)view
{
    [self showLoadingInView:view edgeInset:UIEdgeInsetsZero];
}

+ (void)showLoadingInView:(UIView *)view edgeInset:(UIEdgeInsets)edgeInset
{
    LPLoadingView *loadingView = [self loadViewFromNib];
    
    loadingView.edgeInset = edgeInset;
    
    [loadingView showInView:view];
}

+ (void)hideLoadingForView:(UIView *)view
{
    LPLoadingView *loadingView = [self loadingForView:view];
    if (loadingView) {
        [loadingView hide];
    }
}

+ (void)hideAllLoadingForView:(UIView *)view
{
    NSEnumerator *reverseSubviews = [view.subviews reverseObjectEnumerator];
    for (UIView *subview in reverseSubviews) {
        if ([subview isKindOfClass:self]) {
            [(LPLoadingView *)subview hideNoAnimation];
        }
    }
}

+ (LPLoadingView *)loadingForView:(UIView *)view
{
    NSEnumerator *reverseSubviews = [view.subviews reverseObjectEnumerator];
    for (UIView *subview in reverseSubviews) {
        if ([subview isKindOfClass:self]) {
            return (LPLoadingView *)subview;
        }
    }
    return nil;
}

#pragma mark - 实例方法

- (void)showInView:(UIView *)view
{
    if (!view) {
        return ;
    }
    if (self.superview != view) {
        
        [self removeFromSuperview];
        
        [view addSubview:self];
        
        [view bringSubviewToFront:self];
        
        [self addConstraintInView:view edgeInset:_edgeInset];
    }
    
    [self.imageView startAnimating];
}

- (void)hide
{
    self.alpha = 1.0;
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0;
    }completion:^(BOOL finished) {
        [self hideNoAnimation];
    }];
}

- (void)hideNoAnimation
{
    [self.imageView stopAnimating];
    [self removeFromSuperview];
}

- (void)addConstraintInView:(UIView *)view edgeInset:(UIEdgeInsets)edgeInset
{
    self.translatesAutoresizingMaskIntoConstraints = NO;
    
    [view addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeTop multiplier:1 constant:edgeInset.top]];

    [view addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeLeft multiplier:1 constant:edgeInset.left]];
    
    [view addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeRight multiplier:1 constant:edgeInset.right]];
    
    [view addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeBottom multiplier:1 constant:edgeInset.bottom]];
}

- (void)dealloc
{
    [self.imageView stopAnimating];
    self.imageView.animationImages = nil;
}

@end
