//
//  UIScrollView+TYRefresh.h
//  TYRefreshDemo
//
//  Created by tany on 16/10/10.
//  Copyright © 2016年 tany. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TYRefreshView.h"

@interface UIScrollView (TYRefresh)

@property (nonatomic, strong) TYRefreshView *ty_refreshHeader;

@property (nonatomic, strong) TYRefreshView *ty_refreshFooter;

@end
