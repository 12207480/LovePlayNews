//
//  TYRefreshView+Extension.h
//  TYRefreshDemo
//
//  Created by tany on 16/10/18.
//  Copyright © 2016年 tany. All rights reserved.
//

#import "TYRefreshView.h"

// 延迟执行
NS_INLINE void dispatch_delay_async_ty_refresh(NSTimeInterval delay, dispatch_block_t block)
{
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(),block);
}

@interface TYRefreshView ()

@property (nonatomic, assign) TYRefreshState state;

@property (nonatomic, assign) TYRefreshType type;

@property (nonatomic, copy) TYRefresHandler handler;

@property (weak, nonatomic) id target;

@property (assign, nonatomic) SEL action;

@property (nonatomic, strong) UIView<TYRefreshAnimator> *animator;

@property (nonatomic, assign) CGFloat refreshHeight;

@property (nonatomic, assign) BOOL isRefreshing;

@property (nonatomic, assign) BOOL isEndRefreshAnimating;

@property (nonatomic, assign) BOOL isPanGestureBegin;

@property (nonatomic, assign) UIEdgeInsets scrollViewOrignContenInset;

@end
