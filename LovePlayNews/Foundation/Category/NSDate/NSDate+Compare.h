//
//  NSDate+TY_Compare.h
//  TYFoundationDemo
//
//  Created by tanyang on 15/12/9.
//  Copyright © 2015年 tanyang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (TY_Compare)


/**
 *  计算指定时间与当前的时间差
 *
 *  @param compareDate 某一指定时间
 *
 *  @return 多少(秒or分or天or月or年)+前(比如，3天前、10分钟前)
 */
+(NSString *) compareCurrentTime:(NSDate*) compareDate;

@end
