//
//  TYFPSMonitor.m
//  PrismDemo
//
//  Created by tany on 2017/8/4.
//  Copyright © 2017年 tany. All rights reserved.
//

#import "TYFPSMonitor.h"
#import <UIKit/UIKit.h>
#import "TYWeakProxy.h"

@interface TYFPSMonitor ()

@property (nonatomic, strong) CADisplayLink *displayLink;

@property (nonatomic, assign) NSTimeInterval lastUpdateTime;

@property (nonatomic, assign) NSInteger count;

@property (nonatomic, assign) BOOL delegateFlag;

@end

@implementation TYFPSMonitor

- (instancetype)init {
    if (self = [super init]) {
        _lastUpdateTime = 0;
        _updateFPSInterval = 1.0;
    }
    return self;
}

- (CADisplayLink *)displayLink {
    if (!_displayLink) {
        _displayLink = [CADisplayLink displayLinkWithTarget:[TYWeakProxy proxyWithTarget:self] selector:@selector(updateFPSAction:)];
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 10) {
            _displayLink.preferredFramesPerSecond = 60;
        }else {
            _displayLink.frameInterval = 1;
        }
    }
    return _displayLink;
}

- (void)setDelegate:(id<TYFPSMonitorDelegate>)delegate {
    _delegate = delegate;
    _delegateFlag = [delegate respondsToSelector:@selector(FPSMoitor:didUpdateFPS:)];
}


#pragma mark - public

- (void)start {
    if (_displayLink) {
        return;
    }
    [self.displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
}

- (void)stop {
    if (!_displayLink) {
        return;
    }
    [self.displayLink invalidate];
    _displayLink = nil;
}

#pragma mark - action

- (void)updateFPSAction:(CADisplayLink *)displayLink {
    if (_lastUpdateTime == 0) {
        _lastUpdateTime = displayLink.timestamp;
    }
    ++_count;
    NSTimeInterval interval = displayLink.timestamp - _lastUpdateTime;
    if (interval < _updateFPSInterval) {
        return;
    }
    _lastUpdateTime = displayLink.timestamp;
    float fps = _count/interval;
    _count = 0;
    if (_delegateFlag) {
        [_delegate FPSMoitor:self didUpdateFPS:fps];
    }
}

- (void)dealloc {
    [self stop];
}

@end
