//
//  TYHeaderRefresh.h
//  TYRefreshDemo
//
//  Created by tany on 16/10/14.
//  Copyright © 2016年 tany. All rights reserved.
//

#import "TYRefreshView.h"

@interface TYHeaderRefresh : TYRefreshView

@property (nonatomic, assign) BOOL adjustOriginTopContentInset; // default YES

@property (nonatomic, assign) BOOL adjustViewControllerTopContentInset; // default YES

+ (instancetype)headerWithAnimator:(UIView<TYRefreshAnimator> *)animator handler:(TYRefresHandler)handler;

+ (instancetype)headerWithAnimator:(UIView<TYRefreshAnimator> *)animator target:(id)target action:(SEL)action;

@end
