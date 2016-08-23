//
//  LPNewsCommentOperation.h
//  LovePlayNews
//
//  Created by tany on 16/8/22.
//  Copyright © 2016年 tany. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LPHttpRequest.h"
#import "LPNewsCommentModel.h"

@interface LPNewsCommentOperation : NSObject

+ (LPHttpRequest *)requestHotCommentWithNewsId:(NSString *)newsId;

+ (LPHttpRequest *)requestNewCommentWithNewsId:(NSString *)newsId pageIndex:(NSInteger)pageIndex pageSize:(NSInteger)pageSize;

@end
