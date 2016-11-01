//
//  LPRefreshAutoFooter.m
//  LovePlayNews
//
//  Created by tanyang on 2016/10/31.
//  Copyright © 2016年 tany. All rights reserved.
//

#import "LPRefreshAutoFooter.h"

@implementation LPRefreshAutoFooter

+ (instancetype)footerWithRefreshingTarget:(id)target refreshingAction:(SEL)action
{
    TYAutoAnimatorView *autoAnimatorView = [TYAutoAnimatorView new];
    autoAnimatorView.titleLabelHidden = YES;
    LPRefreshAutoFooter *footer = [self footerWithAnimator:autoAnimatorView target:target action:action];
    return footer;
}

@end
