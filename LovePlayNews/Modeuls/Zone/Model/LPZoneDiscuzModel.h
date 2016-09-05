//
//  LPZoneDiscuzModel.h
//  LovePlayNews
//
//  Created by tany on 16/9/5.
//  Copyright © 2016年 tany. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LPZoneDiscuzModel : NSObject

@property (nonatomic, strong) NSArray *discuzList;

@end

@class LPZoneDiscuzType;
@interface LPZoneDiscuzDetail : NSObject

@property (nonatomic, strong) NSArray *detailList;
@property (nonatomic, strong) LPZoneDiscuzType *type;

@end


@interface LPZoneDiscuzItem : NSObject

@property (nonatomic, strong) NSString *bannerUrl;
@property (nonatomic, assign) NSInteger discuzModelTypeId;
@property (nonatomic, assign) NSInteger fid;
@property (nonatomic, strong) NSString *iconUrl;
@property (nonatomic, strong) NSString *modelDesc;
@property (nonatomic, strong) NSString *modelName;
@property (nonatomic, strong) NSString *todayPosts;
@property (nonatomic, assign) NSInteger weight;

@end

@interface LPZoneDiscuzType : NSObject

@property (nonatomic, strong) NSString *category;
@property (nonatomic, strong) NSString *id;
@property (nonatomic, strong) NSString *typeName;
@property (nonatomic, strong) NSString *weight;

@end