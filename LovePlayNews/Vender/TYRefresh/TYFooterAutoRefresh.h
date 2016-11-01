//
//  TYFooterAutoRefresh.h
//  TYRefreshDemo
//
//  Created by tany on 16/10/18.
//  Copyright © 2016年 tany. All rights reserved.
//

#import "TYRefreshView.h"

@interface TYFooterAutoRefresh : TYRefreshView

@property (nonatomic, assign) BOOL adjustOriginBottomContentInset; // default YES

@property (nonatomic,assign) CGFloat autoRefreshWhenScrollProgress; // default 1.0

@property (nonatomic, assign) BOOL isRefreshEndAutoHidden; // default YES

+ (instancetype)footerWithAnimator:(UIView<TYRefreshAnimator> *)animator handler:(TYRefresHandler)handler;

+ (instancetype)footerWithAnimator:(UIView<TYRefreshAnimator> *)animator target:(id)target action:(SEL)action;

@end
