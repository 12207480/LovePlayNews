//
//  TYHeaderRefresh.m
//  TYRefreshDemo
//
//  Created by tany on 16/10/14.
//  Copyright © 2016年 tany. All rights reserved.
//

#import "TYHeaderRefresh.h"
#import "TYRefreshView+Extension.h"
#import <objc/message.h>

@interface TYHeaderRefresh ()

@end

@implementation TYHeaderRefresh

- (instancetype)init
{
    if (self = [super init]) {
        _adjustViewControllerTopContentInset = YES;
        _adjustOriginTopContentInset = YES;
    }
    return self;
}

+ (instancetype)headerWithAnimator:(UIView<TYRefreshAnimator> *)animator handler:(TYRefresHandler)handler
{
    return [[self alloc]initWithType:TYRefreshTypeHeader animator:animator handler:handler];
}

+ (instancetype)headerWithAnimator:(UIView<TYRefreshAnimator> *)animator target:(id)target action:(SEL)action
{
    return [[self alloc]initWithType:TYRefreshTypeHeader animator:animator target:target action:action];
}

#pragma mark - configure scrollView

- (void)didObserverScrollView:(UIScrollView *)scrollView
{
    [super didObserverScrollView:scrollView];
    
    [self adjsutFrameToScrollView:scrollView];
}

- (void)adjsutFrameToScrollView:(UIScrollView *)scrollView
{
    CGFloat originleftContentInset = self.adjustOriginleftContentInset ? -self.scrollViewOrignContenInset.left : 0;
    CGFloat adjustViewControllerTopContentInset = _adjustViewControllerTopContentInset ? [self adjustsViewControllerScrollViewTopInset:scrollView] : 0;
    CGFloat topContentInset = -self.refreshHeight + (_adjustOriginTopContentInset ? -self.scrollViewOrignContenInset.top + adjustViewControllerTopContentInset : 0);
    
    self.frame = CGRectMake(originleftContentInset,
                                topContentInset,
                                CGRectGetWidth(scrollView.bounds),
                                self.refreshHeight);
}

- (void)adjustViewDidLoadCallBeginRefresh
{
    UIScrollView *scrollView = [self superScrollView];
    if (!self.window && scrollView) {
        UIEdgeInsets contentInset = self.scrollViewOrignContenInset;
        UIViewController *VC = [self viewController];
        if (VC.navigationController && !VC.navigationController.navigationBarHidden && VC.edgesForExtendedLayout&UIRectEdgeTop && VC.automaticallyAdjustsScrollViewInsets) {
            contentInset.top += 64;
        }
        self.scrollViewOrignContenInset = contentInset;
        if (!UIEdgeInsetsEqualToEdgeInsets(scrollView.contentInset, contentInset)) {
            scrollView.contentInset = contentInset;
            [self adjsutFrameToScrollView:scrollView];
        }
    }
}

- (CGFloat)adjustsViewControllerScrollViewTopInset:(UIScrollView *)scrollView
{
    UIViewController *VC = [self viewController];
    
    if (VC && VC.navigationController && VC.automaticallyAdjustsScrollViewInsets) {
        
        return VC.navigationController.navigationBarHidden || scrollView.contentInset.top < 64 ? 0 : 64;
    }
    return 0;
}

- (UIViewController *)viewController
{
    UIScrollView *scrollView = [self superScrollView];
    if (scrollView.superview) {
        UIResponder* nextResponder = [scrollView.superview nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController
                                          class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}

#pragma mark - begin refresh

// 进入刷新状态
- (void)beginRefreshing
{
    UIScrollView *scrollView = [self superScrollView];
    if (!scrollView || self.isRefreshing) {
        return;
    }
    
    self.isRefreshing = YES;
    if (self.hidden) {
        self.hidden = NO;
    }
    
    [self adjustViewDidLoadCallBeginRefresh];
    
    dispatch_async(dispatch_get_main_queue(),^{

        [self beginRefreshingAnimationOnScrollView:scrollView];
    });
}

- (void)beginRefreshingAnimationOnScrollView:(UIScrollView *)scrollView
{
    [UIView animateWithDuration:self.beginAnimateDuring animations:^{
        UIEdgeInsets contentInset = scrollView.contentInset;
            contentInset.top = self.scrollViewOrignContenInset.top + CGRectGetHeight(self.frame);
        scrollView.contentInset = contentInset;
    } completion:^(BOOL finished) {
        self.isPanGestureBegin = NO;
        self.state = TYRefreshStateLoading;
        if ([self.animator respondsToSelector:@selector(refreshViewDidBeginRefresh:)]) {
            [self.animator refreshViewDidBeginRefresh:self];
        }
        
        if (self.target && [self.target respondsToSelector:self.action]) {
            ((void (*)(id, SEL))objc_msgSend)(self.target, self.action);
        }
        
        if (self.handler) {
            self.handler();
        }
    }];
}

// 结束刷新状态
- (void)endRefreshingWithState:(TYRefreshState)state
{
    UIScrollView *scrollView = [self superScrollView];
    if (!scrollView || !self.isRefreshing || self.isEndRefreshAnimating) {
        return;
    }
    
    self.isRefreshing = NO;
    self.isEndRefreshAnimating = YES;
    
    dispatch_async(dispatch_get_main_queue(),^{
        [self endRefreshingAnimationOnScrollView:scrollView state:state];
    });
}

- (void)endRefreshingAnimationOnScrollView:(UIScrollView *)scrollView state:(TYRefreshState)state
{
    [UIView animateWithDuration:self.endAnimateDuring animations:^{
        UIEdgeInsets contentInset = scrollView.contentInset;
        contentInset.top = self.scrollViewOrignContenInset.top;
        scrollView.contentInset = contentInset;
//        [scrollView setContentOffset:CGPointMake(0, -contentInset.top) animated:NO];
    } completion:^(BOOL finished) {
        self.isEndRefreshAnimating = NO;
        
        if ([self.animator respondsToSelector:@selector(refreshViewDidEndRefresh:)]) {
            [self.animator refreshViewDidEndRefresh:self];
        }
        self.state = state;
    }];
}

- (void)endRefreshing
{
    [self endRefreshingWithState:TYRefreshStateNormal];
}

- (void)endRefreshingWithNoMoreData
{
    [self endRefreshingWithState:TYRefreshStateNoMore];
}

- (void)endRefreshingWithError
{
    [self endRefreshingWithState:TYRefreshStateError];
}

#pragma mark - observe scrollView

- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change
{
    if (![self superScrollView]) {
        return;
    }
    
    [self scrollViewContentOffsetDidChangeHeader];
}

- (void)scrollViewContentOffsetDidChangeHeader
{
    UIScrollView *scrollView = [self superScrollView];
    
    if (CGRectGetHeight(scrollView.frame)<= 0 || self.refreshHeight <= 0) {
        return;
    }
    
    if (self.isRefreshing) {
        // 处理 section header
        CGFloat contentInsetTop = scrollView.contentOffset.y > -self.scrollViewOrignContenInset.top ? self.scrollViewOrignContenInset.top : -scrollView.contentOffset.y;
        UIEdgeInsets contentInset = scrollView.contentInset;
        contentInset.top = MIN(self.scrollViewOrignContenInset.top + CGRectGetHeight(self.frame), contentInsetTop);
        scrollView.contentInset = contentInset;
        return;
    }
    
    if (self.isEndRefreshAnimating) {
        // 结束动画
        return;
    }
    //NSLog(@"offsetY %.f contentTop %.f",scrollView.contentOffset.y,scrollView.contentInset.top);
    BOOL isChangeContentInsetTop = self.scrollViewOrignContenInset.top != scrollView.contentInset.top;
    self.scrollViewOrignContenInset = scrollView.contentInset;
    if (isChangeContentInsetTop) {
        [self adjsutFrameToScrollView:scrollView];
    }
    
    if (scrollView.panGestureRecognizer.state == UIGestureRecognizerStateBegan) {
        self.isPanGestureBegin = YES;
        return;
    }
    
    if (!self.isPanGestureBegin) { // 没有拖拽
        return;
    }
    
    if (scrollView.contentOffset.y > -self.scrollViewOrignContenInset.top) { // 还没到临界点
        return;
    }
    
    if (![self canPullingRefresh]) {
        return;
    }
    
    CGFloat progress = (-self.scrollViewOrignContenInset.top - scrollView.contentOffset.y) / CGRectGetHeight(self.frame);
    
    [self refreshViewDidChangeProgress:progress];
}

- (void)scrollViewContentSizeDidChange:(NSDictionary *)change
{
    UIScrollView *scrollView = [self superScrollView];
    if (!scrollView) {
        return;
    }
    
    CGSize oldContentSize = [[change valueForKey:NSKeyValueChangeOldKey] CGSizeValue];
    CGSize newContentSize = [[change valueForKey:NSKeyValueChangeNewKey] CGSizeValue];
    
    if (CGSizeEqualToSize(oldContentSize, newContentSize)) {
        return;
    }
    
    if (oldContentSize.width != newContentSize.width) {
        CGRect frame = self.frame;
        frame.size.width = CGRectGetWidth(scrollView.bounds);
        self.frame = frame;
    }
}

@end
