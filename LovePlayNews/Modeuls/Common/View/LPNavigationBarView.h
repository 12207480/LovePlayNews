//
//  LPNavigationBarView.h
//  LovePlayNews
//
//  Created by tanyang on 16/8/20.
//  Copyright © 2016年 tany. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LPNavigationBarView : UIView

@property (nonatomic, strong) NSString *title;

@property (nonatomic, assign) CGFloat backgroundAlpha;

@property (nonatomic, copy) void (^navBackHandle)(void);

@end
