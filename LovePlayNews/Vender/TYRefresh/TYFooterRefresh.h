//
//  TYFooterRefresh.h
//  TYRefreshDemo
//
//  Created by tany on 16/10/14.
//  Copyright © 2016年 tany. All rights reserved.
//

#import "TYRefreshView.h"

@interface TYFooterRefresh : TYRefreshView

@property (nonatomic, assign) BOOL adjustOriginBottomContentInset; // default YES

@property (nonatomic, assign) BOOL isRefreshEndAutoHidden; // default YES

+ (instancetype)footerWithAnimator:(UIView<TYRefreshAnimator> *)animator handler:(TYRefresHandler)handler;

+ (instancetype)footerWithAnimator:(UIView<TYRefreshAnimator> *)animator target:(id)target action:(SEL)action;

@end
