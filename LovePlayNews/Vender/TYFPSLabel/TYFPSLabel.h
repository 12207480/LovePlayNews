//
//  TYFPSLabel.h
//  PrismDemo
//
//  Created by tany on 2017/8/4.
//  Copyright © 2017年 tany. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TYFPSLabel : UILabel

+ (void)showInStutasBar;
+ (void)hide;

- (void)start;
- (void)stop;

@end
