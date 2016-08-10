//
//  LPNewsDetailModel.h
//  LovePlayNews
//
//  Created by tany on 16/8/10.
//  Copyright © 2016年 tany. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LPNewsArticleModel;
@interface LPNewsDetailModel : NSObject

@property (nonatomic,strong) LPNewsArticleModel *article;

@end

@interface LPNewsArticleModel : NSObject

@property (nonatomic, strong) NSString *articleUrl;
@property (nonatomic, strong) NSString *body;
@property (nonatomic, strong) NSString *digest;
@property (nonatomic, strong) NSString *docid;
@property (nonatomic, strong) NSArray *img;
@property (nonatomic, strong) NSString *ptime;
@property (nonatomic, assign) NSInteger replyCount;
@property (nonatomic, strong) NSString *shareLink;
@property (nonatomic, strong) NSString *source;
@property (nonatomic, strong) NSString *title;

@end

@interface LPNewsDetailImgeInfo : NSObject

@property (nonatomic, strong) NSString *pixel;
@property (nonatomic, strong) NSString *ref;
@property (nonatomic, strong) NSString *src;

@end

