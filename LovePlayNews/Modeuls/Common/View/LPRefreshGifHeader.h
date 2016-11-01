//
//  LPRefreshGifHeader.h
//  LovePlayNews
//
//  Created by tany on 16/8/23.
//  Copyright © 2016年 tany. All rights reserved.
//

#import "TYRefresh.h"

@interface LPRefreshGifHeader : TYHeaderRefresh

+ (instancetype)headerWithRefreshingTarget:(id)target refreshingAction:(SEL)action;

@end
