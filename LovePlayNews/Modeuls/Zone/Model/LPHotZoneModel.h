//
//  LPHotZoneModel.h
//  LovePlayNews
//
//  Created by tanyang on 16/9/4.
//  Copyright © 2016年 tany. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LPHotZoneModel : NSObject

@property (nonatomic, strong) NSArray *focusList;
@property (nonatomic, strong) NSArray *forumList;
@property (nonatomic, strong) NSArray *threadList;

@end

@interface LPZoneFocus : NSObject

@property (nonatomic, strong) NSString *img;
@property (nonatomic, strong) NSString *tid;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *url;

@end

@interface LPZoneForum : NSObject

@property (nonatomic, strong) NSString *desc;
@property (nonatomic, assign) NSInteger discuzModelTypeId;
@property (nonatomic, strong) NSString *fid;
@property (nonatomic, strong) NSString *icon;
@property (nonatomic, strong) NSString *title;

@end

@interface LPZoneThread : NSObject

@property (nonatomic, strong) NSString *author;
@property (nonatomic, strong) NSString *authorid;
@property (nonatomic, strong) NSString *dateline;
@property (nonatomic, strong) NSString *digest;
@property (nonatomic, strong) NSString *fid;
@property (nonatomic, strong) NSString *fname;
@property (nonatomic, strong) NSString *lastpost;
@property (nonatomic, strong) NSString *lastposter;
@property (nonatomic, strong) NSString *lastposterid;
@property (nonatomic, strong) NSString *replies;
@property (nonatomic, strong) NSString *subject;
@property (nonatomic, strong) NSString *tid;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *typeid;
@property (nonatomic, strong) NSString *typename;
@property (nonatomic, strong) NSString *views;

@end

