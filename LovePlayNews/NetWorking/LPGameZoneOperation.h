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

@interface LPGameZoneOperation : NSObject

+ (LPHttpRequest *)requestHotZoneWithPageIndex:(NSInteger)pageIndex;

+ (LPHttpRequest *)requestZoneDiscuzWithIndex:(NSInteger)index;

@end
