//
//  TYFPSMonitor.h
//  PrismDemo
//
//  Created by tany on 2017/8/4.
//  Copyright © 2017年 tany. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TYFPSMonitor;
@protocol TYFPSMonitorDelegate <NSObject>

- (void)FPSMoitor:(TYFPSMonitor *)FPSMoitor didUpdateFPS:(float)fps;

@end

@interface TYFPSMonitor : NSObject

@property (nonatomic, weak) id<TYFPSMonitorDelegate> delegate;

@property (nonatomic, assign) NSTimeInterval updateFPSInterval; // default 1.0s

- (void)start;

- (void)stop;

@end
