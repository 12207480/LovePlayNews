//
//  UIScrollView+TYRefresh.m
//  TYRefreshDemo
//
//  Created by tany on 16/10/10.
//  Copyright © 2016年 tany. All rights reserved.
//

#import "UIScrollView+TYRefresh.h"
#import <objc/runtime.h>

static char TYRefreshHeaderKey;
static char TYRefreshFooterKey;

@implementation UIScrollView (TYRefresh)

- (TYRefreshView *)ty_refreshHeader
{
    return objc_getAssociatedObject(self, &TYRefreshHeaderKey);
}

- (void)setTy_refreshHeader:(TYRefreshView *)ty_refreshHeader
{
    if (self.ty_refreshHeader) {
        [self.ty_refreshHeader removeFromSuperview];
    }
    
    if (ty_refreshHeader) {
        objc_setAssociatedObject(self, &TYRefreshHeaderKey, ty_refreshHeader,OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        
        [self ty_addHeaderRefreshView:ty_refreshHeader];
    }
}

- (TYRefreshView *)ty_refreshFooter
{
    return objc_getAssociatedObject(self, &TYRefreshFooterKey);
}

- (void)setTy_refreshFooter:(TYRefreshView *)ty_refreshFooter
{
    if (self.ty_refreshFooter) {
        [self.ty_refreshFooter removeFromSuperview];
    }
    
    if (ty_refreshFooter) {
        objc_setAssociatedObject(self, &TYRefreshFooterKey, ty_refreshFooter,OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        
        [self ty_addFooterRefreshView:ty_refreshFooter];
    }
}

#pragma mark - add subView

- (void)ty_addHeaderRefreshView:(TYRefreshView *)refreshHeader
{
    [self addSubview:refreshHeader];
}

- (void)ty_addFooterRefreshView:(TYRefreshView *)refreshFooter
{
    [self addSubview:refreshFooter];
}

@end
