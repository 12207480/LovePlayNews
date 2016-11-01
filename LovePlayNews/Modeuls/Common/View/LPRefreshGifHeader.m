//
//  LPRefreshGifHeader.m
//  LovePlayNews
//
//  Created by tany on 16/8/23.
//  Copyright © 2016年 tany. All rights reserved.
//

#import "LPRefreshGifHeader.h"

static NSArray *refreshingImages = nil;

@implementation LPRefreshGifHeader

+ (void)initialize
{
    if (!refreshingImages) {
        NSMutableArray *images  = [NSMutableArray array];
        for (int i = 1; i< 5; ++i) {
            UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"refresh%d",i]];
            [images addObject:image];
        }
        refreshingImages = [images copy];
    }
}

+ (instancetype)headerWithRefreshingTarget:(id)target refreshingAction:(SEL)action
{
    TYGifAnimatorView *gifAnimatorView = [TYGifAnimatorView new];
    gifAnimatorView.animationDuration = 0.5;
    gifAnimatorView.titleLabelHidden = YES;
    [gifAnimatorView setGifImages:refreshingImages forState:TYRefreshStatePulling];
    [gifAnimatorView setGifImages:refreshingImages forState:TYRefreshStateLoading];
    LPRefreshGifHeader *header = [self headerWithAnimator:gifAnimatorView target:target action:action];
    return header;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
