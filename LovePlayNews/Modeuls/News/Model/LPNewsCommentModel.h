//
//  LPNewsCommonModel.h
//  LovePlayNews
//
//  Created by tany on 16/8/10.
//  Copyright © 2016年 tany. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LPNewsCommentModel : NSObject
@property (nonatomic, strong) NSArray *commentIds;
@property (nonatomic, strong) NSDictionary *comments;

@end

@class LPNewsCommentUser;
@interface LPNewsCommentItem : NSObject

@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *createTime;
@property (nonatomic, strong) NSString *siteName;
@property (nonatomic, strong) LPNewsCommentUser *user;
@property (nonatomic, assign) NSInteger vote;
@end

@interface LPNewsCommentUser : NSObject
@property (nonatomic, strong) NSString *avatar;
@property (nonatomic, strong) NSString *location;
@property (nonatomic, strong) NSString *nickname;

@end