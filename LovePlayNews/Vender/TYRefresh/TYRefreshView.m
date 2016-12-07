//
//  TYRefreshView.m
//  TYRefreshDemo
//
//  Created by tany on 16/10/10.
//  Copyright © 2016年 tany. All rights reserved.
//

#import "TYRefreshView.h"
#import "TYRefreshView+Extension.h"

// scrollView KVO
static NSString *const kTYRefreshContentOffsetKey = @"contentOffset";
static NSString *const kTYRefreshContentSizeKey = @"contentSize";
static char kTYRefreshContentKey;

#define kRefreshViewHeight 60

@implementation TYRefreshView

- (instancetype)init
{
    if (self = [super init]) {
        _beginAnimateDuring = 0.25;
        _endAnimateDuring = 0.25;
        _adjustOriginleftContentInset = NO;
    }
    return self;
}

- (instancetype)initWithHeight:(CGFloat)height type:(TYRefreshType)type animator:(UIView<TYRefreshAnimator> *)animator handler:(TYRefresHandler)handler
{
    if (self = [self init]) {
        _refreshHeight = height;
        _type = type;
        _animator = animator;
        _handler = handler;
        
        [self addAnimatorView];
    }
    return self;
}

- (instancetype)initWithType:(TYRefreshType)type animator:(UIView<TYRefreshAnimator> *)animator handler:(TYRefresHandler)handler
{
    return [self initWithHeight:CGRectGetHeight(animator.frame) > 0 ? CGRectGetHeight(animator.frame) : kRefreshViewHeight type:type animator:animator handler:handler];
}

- (instancetype)initWithHeight:(CGFloat)height type:(TYRefreshType)type animator:(UIView<TYRefreshAnimator> *)animator target:(id)target action:(SEL)action
{
    if (self = [self init]) {
        _refreshHeight = height;
        _type = type;
        _animator = animator;
        _target = target;
        _action = action;
        
        [self addAnimatorView];
    }
    return self;
}


- (instancetype)initWithType:(TYRefreshType)type animator:(UIView<TYRefreshAnimator> *)animator target:(id)target action:(SEL)action
{
    return [self initWithHeight:CGRectGetHeight(animator.frame) > 0 ? CGRectGetHeight(animator.frame) : kRefreshViewHeight type:type animator:animator target:target action:action];
}


#pragma mark - getter

- (UIScrollView *)superScrollView
{
    if (self.superview && [self.superview isKindOfClass:[UIScrollView class]]) {
        return (UIScrollView *)self.superview;
    }
    return nil;
}

- (BOOL)canPullingRefresh
{
    return _state == TYRefreshStateNone || _state == TYRefreshStateNormal || _state == TYRefreshStatePulling || _state == TYRefreshStateRelease;
}

#pragma mark - setter

- (void)setState:(TYRefreshState)state
{
    if (_state != state) {
        TYRefreshState oldState = _state;
        _state = state;
        if ([_animator respondsToSelector:@selector(refreshView:didChangeFromState:toState:)]) {
            [_animator refreshView:self didChangeFromState:oldState toState:state];
        }
    }
}

#pragma mark - add subview

- (void)addAnimatorView
{
    NSAssert(_animator != nil, @"animator can't nil!");
    NSAssert([_animator isKindOfClass:[UIView class]], @"animator must is UIView subClass!");

    [self addSubview:_animator];
    
    [self addConstraintWithView:_animator edgeInset:UIEdgeInsetsZero];
    
    if ([_animator respondsToSelector:@selector(refreshViewDidPrepareRefresh:)]) {
        [_animator refreshViewDidPrepareRefresh:self];
    }
    
    self.state = TYRefreshStateNormal;
}

- (void)addConstraintWithView:(UIView *)view edgeInset:(UIEdgeInsets)edgeInset
{
    view.translatesAutoresizingMaskIntoConstraints = NO;
    [self addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:edgeInset.top]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1 constant:edgeInset.left]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1 constant:edgeInset.right]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1 constant:edgeInset.bottom]];
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    [super willMoveToSuperview:newSuperview];
    
    UIScrollView *scrollView = [self superScrollView];
    if (scrollView) {
        [self removeObserverScrollView:scrollView];
    }
    
    if (newSuperview && [newSuperview isKindOfClass:[UIScrollView class]]) {
        UIScrollView *scrollView = (UIScrollView *)newSuperview;
        
        [self willObserverScrollView:scrollView];
        
        [self addObserverScrollView:scrollView];
        
        [self didObserverScrollView:scrollView];
    }
}

- (void)willObserverScrollView:(UIScrollView *)scrollView
{
    
}

- (void)didObserverScrollView:(UIScrollView *)scrollView
{
    scrollView.alwaysBounceVertical = YES;
    self.scrollViewOrignContenInset = scrollView.contentInset;
}


#pragma mark - refresh

// 进入刷新状态
- (void)beginRefreshing
{
   
}

// 结束刷新状态
- (void)endRefreshing
{
    
}

- (void)endRefreshingWithNoMoreData
{
    
}

- (void)endRefreshingWithError
{
    
}

- (void)resetNormalState
{
    self.state = TYRefreshStateNormal;
}

#pragma mark - Observer scrollView

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if (context != &kTYRefreshContentKey) {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        return;
    }
    
    if ([keyPath isEqualToString:kTYRefreshContentOffsetKey]) {
        [self scrollViewContentOffsetDidChange:change];
    }else if ([keyPath isEqualToString:kTYRefreshContentSizeKey]) {
        [self scrollViewContentSizeDidChange:change];
    }else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change
{
    
}

- (void)scrollViewContentSizeDidChange:(NSDictionary *)change
{
    
}

- (void)refreshViewDidChangeProgress:(CGFloat)progress
{
    if ([self superScrollView].isDragging) {
        if (progress >= 1.0) {
            self.state = TYRefreshStateRelease;
        }else if (progress <= 0.0) {
            self.state = TYRefreshStateNormal;
        }else {
            self.state = TYRefreshStatePulling;
        }
    }else if (self.state == TYRefreshStateRelease) {
        [self beginRefreshing];
    }else {
        if (progress <= 0.0) {
            self.state = TYRefreshStateNormal;
        }
    }
    
    if ([_animator respondsToSelector:@selector(refreshView:didChangeProgress:)]) {
        [_animator refreshView:self didChangeProgress:MAX(MIN(progress, 1.0), 0.0)];
    }
}

- (void)removeObserverScrollView:(UIScrollView *)scrollView
{
    [scrollView removeObserver:self forKeyPath:kTYRefreshContentOffsetKey context:&kTYRefreshContentKey];
    [scrollView removeObserver:self forKeyPath:kTYRefreshContentSizeKey context:&kTYRefreshContentKey];
}

- (void)addObserverScrollView:(UIScrollView *)scrollView
{
    [scrollView addObserver:self forKeyPath:kTYRefreshContentOffsetKey options:NSKeyValueObservingOptionInitial context:&kTYRefreshContentKey];
    [scrollView addObserver:self forKeyPath:kTYRefreshContentSizeKey options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:&kTYRefreshContentKey];
}

- (void)dealloc
{
    UIScrollView *scrollView = [self superScrollView];
    if (scrollView) {
        [self removeObserverScrollView:scrollView];
    }
}

@end
