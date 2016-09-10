//
//  LPDiscuzDetailModel.h
//  LovePlayNews
//
//  Created by tanyang on 16/9/8.
//  Copyright © 2016年 tany. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <TYTextContainer.h>

@class LPDiscuzThread;
@interface LPDiscuzDetailModel : NSObject

@property (nonatomic, strong) NSString *fid;
@property (nonatomic, strong) LPDiscuzThread *thread;
@property (nonatomic, strong) NSArray *postlist;

@end

@interface LPDiscuzThread : NSObject

@property (nonatomic, strong) NSString *tid;
@property (nonatomic, strong) NSString *fid;
@property (nonatomic, strong) NSString *author;
@property (nonatomic, strong) NSString *subject;
@property (nonatomic, strong) NSString *lastpost;
@property (nonatomic, strong) NSString *lastposter;
@property (nonatomic, strong) NSString *views;
@property (nonatomic, strong) NSString *replies;
@property (nonatomic, strong) NSString *typename;

@end

@interface LPDiscuzPost : NSObject

@property (nonatomic, strong) NSString *pid;
@property (nonatomic, strong) NSString *tid;
@property (nonatomic, assign) NSInteger first;
@property (nonatomic, strong) NSString *author;
@property (nonatomic, strong) NSString *authorid;
@property (nonatomic, strong) NSString *dateline;
@property (nonatomic, strong) NSString *message;
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *replyText;

@property (nonatomic, strong) TYTextContainer *textContainer;

@end

