//
//  LPRecommendOperation.h
//  LovePlayNews
//
//  Created by tany on 16/8/26.
//  Copyright © 2016年 tany. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LPHttpRequest.h"

@interface LPRecommendOperation : NSObject

+ (LPHttpRequest *)requestRecommendTopicList;

+ (LPHttpRequest *)requestRecommendImageInfos;

@end
