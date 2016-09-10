//
//  LPNewsZoneOperation.h
//  LovePlayNews
//
//  Created by tanyang on 16/9/4.
//  Copyright © 2016年 tany. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LPHttpRequest.h"
#import "LPHotZoneModel.h"
#import "LPZoneDiscuzModel.h"
#import "LPDiscuzListModel.h"
#import "LPDiscuzDetailModel.h"

@interface LPGameZoneOperation : NSObject

+ (LPHttpRequest *)requestHotZoneWithPageIndex:(NSInteger)pageIndex;

+ (LPHttpRequest *)requestZoneDiscuzWithIndex:(NSInteger)index;

+ (LPHttpRequest *)requestDiscuzImageWithFid:(NSString *)fid;

+ (LPHttpRequest *)requestDiscuzListWithFid:(NSString *)fid Index:(NSInteger)index;

+ (LPHttpRequest *)requestDiscuzDetailWithTid:(NSString *)tid index:(NSInteger)index pageSize:(NSInteger)pageSize;

@end
