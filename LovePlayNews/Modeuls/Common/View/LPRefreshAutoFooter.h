//
//  LPRefreshAutoFooter.h
//  LovePlayNews
//
//  Created by tanyang on 2016/10/31.
//  Copyright © 2016年 tany. All rights reserved.
//

#import "TYRefresh.h"

@interface LPRefreshAutoFooter : TYFooterAutoRefresh

+ (instancetype)footerWithRefreshingTarget:(id)target refreshingAction:(SEL)action;

@end
