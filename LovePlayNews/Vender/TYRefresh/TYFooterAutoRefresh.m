//
//  TYFooterAutoRefresh.m
//  TYRefreshDemo
//
//  Created by tany on 16/10/18.
//  Copyright © 2016年 tany. All rights reserved.
//

#import "TYFooterAutoRefresh.h"
#import "TYRefreshView+Extension.h"
#import <objc/message.h>

@interface TYFooterAutoRefresh ()

@property (nonatomic, assign) CGFloat beginRefreshOffset;

@property (nonatomic, assign) UIEdgeInsets scrollViewAdjustContenInset;

@property (nonatomic, assign) BOOL isUpdateContentSize;

@end

@implementation TYFooterAutoRefresh

- (instancetype)init
{
    if (self = [super init]) {
        _adjustOriginBottomContentInset = YES;
        _autoRefreshWhenScrollProgress = 0.0;
        _isRefreshEndAutoHidden = YES;
    }
    return self;
}

+ (instancetype)footerWithAnimator:(UIView<TYRefreshAnimator> *)animator handler:(TYRefresHandler)handler
{
    return [[self alloc]initWithType:TYRefreshTypeFooter animator:animator handler:handler];
}

+ (instancetype)footerWithAnimator:(UIView<TYRefreshAnimator> *)animator target:(id)target action:(SEL)action
{
    return [[self alloc]initWithType:TYRefreshTypeFooter animator:animator target:target action:action];
}

#pragma mark - configure scrollView

- (void)didObserverScrollView:(UIScrollView *)scrollView
{
    [super didObserverScrollView:scrollView];
}

- (void)adjsutFrameToScrollView:(UIScrollView *)scrollView
{
    CGFloat originleftContentInset = self.adjustOriginleftContentInset ? -self.scrollViewOrignContenInset.left : 0;
    
    CGFloat contentOnScreenHeight = CGRectGetHeight(scrollView.frame) - self.scrollViewOrignContenInset.top;
    CGFloat bottomContentInset = MAX(scrollView.contentSize.height+self.scrollViewOrignContenInset.bottom, contentOnScreenHeight-self.refreshHeight) - (_adjustOriginBottomContentInset ? 0 : self.scrollViewOrignContenInset.bottom);
    self.frame = CGRectMake(originleftContentInset,
                            bottomContentInset,
                            CGRectGetWidth(scrollView.bounds),
                            self.refreshHeight);
    _isUpdateContentSize = YES;
    if (self.hidden) {
        self.hidden = NO;
    }
}

- (CGFloat)adjustContentInsetBottom
{
    return _adjustOriginBottomContentInset ? self.refreshHeight : MAX(self.refreshHeight, self.scrollViewOrignContenInset.bottom);
}

- (void)setState:(TYRefreshState)state
{
    if (!_isUpdateContentSize && (state == TYRefreshStateNormal || state == TYRefreshStateNoMore || state == TYRefreshStateError)) {
        _isUpdateContentSize = YES;
        self.hidden = _isRefreshEndAutoHidden;
    }
    [super setState:state];
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
    
    dispatch_async(dispatch_get_main_queue(),^{
        [self beginRefreshingAnimationOnScrollView:scrollView];
    });
}

- (void)beginRefreshingAnimationOnScrollView:(UIScrollView *)scrollView
{
    
    self.isPanGestureBegin = NO;
    self.state = TYRefreshStateLoading;
    
    if ([self.animator respondsToSelector:@selector(refreshViewDidBeginRefresh:)]) {
        [self.animator refreshViewDidBeginRefresh:self];
    }
    
    dispatch_delay_async_ty_refresh(0.35, ^{
        _isUpdateContentSize = NO;
        if (self.target && [self.target respondsToSelector:self.action]) {
            ((void (*)(id, SEL))objc_msgSend)(self.target, self.action);
        }
        
        if (self.handler) {
            self.handler();
        }
    });
    
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
    self.isEndRefreshAnimating = NO;
    
    if ([self.animator respondsToSelector:@selector(refreshViewDidEndRefresh:)]) {
        [self.animator refreshViewDidEndRefresh:self];
    }
    
    self.state = state;
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
    
    [self scrollViewContentOffsetDidChangeFooter];
}

- (void)scrollViewContentOffsetDidChangeFooter
{
    UIScrollView *scrollView = [self superScrollView];
    
    if (CGRectGetHeight(scrollView.frame)<= 0 || self.refreshHeight <= 0) {
        return;
    }
    
    if (self.isRefreshing) {
        return;
    }
    
    if (!UIEdgeInsetsEqualToEdgeInsets(_scrollViewAdjustContenInset, scrollView.contentInset) || UIEdgeInsetsEqualToEdgeInsets(_scrollViewAdjustContenInset,UIEdgeInsetsZero)) {
        if (scrollView.contentInset.bottom != _scrollViewAdjustContenInset.bottom || UIEdgeInsetsEqualToEdgeInsets(_scrollViewAdjustContenInset,UIEdgeInsetsZero)) {
            self.scrollViewOrignContenInset = scrollView.contentInset;
            UIEdgeInsets  scrollViewAdjustContenInset = scrollView.contentInset;
            scrollViewAdjustContenInset.bottom += self.refreshHeight;
            _scrollViewAdjustContenInset = scrollViewAdjustContenInset;
        }else {
            UIEdgeInsets scrollViewOrignContenInset = scrollView.contentInset;
            scrollViewOrignContenInset.bottom = self.scrollViewOrignContenInset.bottom;
            self.scrollViewOrignContenInset = scrollViewOrignContenInset;
            
            UIEdgeInsets scrollViewAdjustContenInset = scrollView.contentInset;
            scrollViewAdjustContenInset.bottom = _scrollViewAdjustContenInset.bottom;
            _scrollViewAdjustContenInset = scrollViewAdjustContenInset;
            
        }
        
        if (!UIEdgeInsetsEqualToEdgeInsets(_scrollViewAdjustContenInset, scrollView.contentInset)) {
            scrollView.contentInset = _scrollViewAdjustContenInset;
        }
    }
    
    if (scrollView.panGestureRecognizer.state == UIGestureRecognizerStateBegan) {
        self.isPanGestureBegin = YES;
        // 刷新临界点 需要判断内容高度是否大于scrollView的高度
        CGFloat willPullRefreshOffsetY = self.frame.origin.y - scrollView.frame.size.height + (_adjustOriginBottomContentInset ? 0 :  self.scrollViewOrignContenInset.bottom);
        _beginRefreshOffset =  willPullRefreshOffsetY > 0 ? willPullRefreshOffsetY : -self.scrollViewOrignContenInset.top;
        return;
    }
    
    if (!self.isPanGestureBegin) { // 没有拖拽
        return;
    }
    
    if (scrollView.contentOffset.y < _beginRefreshOffset) {
        // 还没到刷新点
        return;
    }
    
    if (self.hidden) {
        self.hidden = NO;
    }
    
    if (![self canPullingRefresh]) {
        return;
    }
    
    CGFloat progress = (scrollView.contentOffset.y - _beginRefreshOffset) / CGRectGetHeight(self.frame);
    
    [self refreshViewDidChangeProgress:progress];
}

- (void)refreshViewDidChangeProgress:(CGFloat)progress
{
    if (self.state == TYRefreshStateNormal) {
        if (progress >= _autoRefreshWhenScrollProgress) {
            [self beginRefreshing];
        }
    }
}

- (void)scrollViewContentSizeDidChange:(NSDictionary *)change
{
    UIScrollView *scrollView = [self superScrollView];
    if (!scrollView) {
        return;
    }
    
    [self adjsutFrameToScrollView:scrollView];
}


@end
