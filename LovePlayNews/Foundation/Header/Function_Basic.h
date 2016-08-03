//
//  Function_Basic.h
//  TYFoundationDemo
//
//  Created by tanyang on 15/12/23.
//  Copyright © 2015年 tanyang. All rights reserved.
//

#ifndef Function_Basic_h
#define Function_Basic_h

#ifdef __OBJC__
#import <UIKit/UIKit.h>

#endif

//系统版本
NS_INLINE float device_version()
{
    return [[[UIDevice currentDevice] systemVersion] floatValue];
}

// 延迟执行
NS_INLINE void dispatch_delay_async(NSTimeInterval delay, dispatch_block_t block)
{
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(),block);
}

// 主线程执行
NS_INLINE void dispatch_main_async(dispatch_block_t block) {
    if ([NSThread isMainThread]) {
        block();
    } else {
        dispatch_async(dispatch_get_main_queue(), block);
    }
}

#endif /* Function_Basic_h */
