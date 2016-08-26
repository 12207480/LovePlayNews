//
//  LPRecommendItem.h
//  LovePlayNews
//
//  Created by tany on 16/8/26.
//  Copyright © 2016年 tany. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LPRecommendItem : NSObject

@property (nonatomic, strong) NSString *bannerUrl;
@property (nonatomic, strong) NSString *desc;
@property (nonatomic, strong) NSString *iconUrl;
@property (nonatomic, strong) NSString *topicIconName;
@property (nonatomic, strong) NSString *topicId;
@property (nonatomic, strong) NSString *topicName;
@property (nonatomic, assign) NSInteger followUserCount;
@property (nonatomic, assign) NSInteger platform;
@property (nonatomic, assign) NSInteger sourceType;

@end
