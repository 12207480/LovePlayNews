//
//  LPNewsRequestOperation.h
//  LovePlayNews
//
//  Created by tany on 16/8/3.
//  Copyright © 2016年 tany. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TYModelRequest.h"
#import "LPNewsInfoModel.h"

@interface LPNewsRequestOperation : NSObject

+ (TYModelRequest *)requestNewsListWithPageIndex:(NSInteger)pageIndex;

@end
