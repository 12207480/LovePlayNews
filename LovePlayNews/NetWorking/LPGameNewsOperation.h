//
//  LPNewsRequestOperation.h
//  LovePlayNews
//
//  Created by tany on 16/8/3.
//  Copyright © 2016年 tany. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LPHttpRequest.h"
#import "LPNewsInfoModel.h"
#import "LPNewsDetailModel.h"

@interface LPGameNewsOperation : NSObject

+ (LPHttpRequest *)requestNewsListWithTopId:(NSString *)topId pageIndex:(NSInteger)pageIndex;

+ (LPHttpRequest *)requestNewsDetailWithNewsId:(NSString *)newsId;

@end
