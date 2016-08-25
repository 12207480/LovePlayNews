//
//  LPRefreshGifHeader.m
//  LovePlayNews
//
//  Created by tany on 16/8/23.
//  Copyright © 2016年 tany. All rights reserved.
//

#import "LPRefreshGifHeader.h"

@implementation LPRefreshGifHeader

+ (instancetype)headerWithRefreshingTarget:(id)target refreshingAction:(SEL)action
{
    LPRefreshGifHeader *header = [super headerWithRefreshingTarget:target refreshingAction:action];
    header.lastUpdatedTimeLabel.hidden = YES;
    header.lastUpdatedTimeLabel.hidden = YES;
    header.stateLabel.hidden = YES;
    NSMutableArray *refreshingImages  = [NSMutableArray array];
    for (int i = 1; i< 5; ++i) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"refresh%d",i]];
        [refreshingImages addObject:image];
    }
    [header setImages:@[refreshingImages.firstObject] forState:MJRefreshStateIdle];
    [header setImages:@[refreshingImages.firstObject] forState:MJRefreshStatePulling];
    [header setImages:[refreshingImages copy] forState:MJRefreshStateRefreshing];
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
