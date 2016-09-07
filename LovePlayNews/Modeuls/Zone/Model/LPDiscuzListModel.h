//
//  LPDiscuzDeailModel.h
//  LovePlayNews
//
//  Created by tany on 16/9/7.
//  Copyright © 2016年 tany. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LPDiscuzforum;
@interface LPDiscuzListModel : NSObject

@property (nonatomic, strong) LPDiscuzforum *forum;

@property (nonatomic, strong) NSArray *forum_threadlist;

@end

@interface LPDiscuzforum : NSObject

@property (nonatomic, strong) NSString *fid;
@property (nonatomic, strong) NSString *icon;
@property (nonatomic, strong) NSString *fup;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *threads;
@property (nonatomic, strong) NSString *posts;
@property (nonatomic, strong) NSString *todayposts;

@end

@interface LPForumThread : NSObject

@property (nonatomic, strong) NSString *tid;
@property (nonatomic, strong) NSString *typeid;
@property (nonatomic, strong) NSString *author;
@property (nonatomic, strong) NSString *authorid;
@property (nonatomic, strong) NSString *subject;
@property (nonatomic, strong) NSString *dateline;
@property (nonatomic, strong) NSString *lastpost;
@property (nonatomic, strong) NSString *lastposter;
@property (nonatomic, strong) NSString *replies;
@property (nonatomic, assign) NSInteger displayorder;

@end
