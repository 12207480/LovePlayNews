//
//  LPNewsCommonModel.m
//  LovePlayNews
//
//  Created by tany on 16/8/10.
//  Copyright © 2016年 tany. All rights reserved.
//

#import "LPNewsCommentModel.h"
#import "TYJSONModel.h"

@implementation LPNewsCommentModel

- (BOOL)shouldCustomUnkownValueWithKey:(NSString *)key
{
    if ([key isEqualToString:@"comments"]) {
        return YES;
    }
    return NO;
}

- (id)customValueWithKey:(NSString *)key unkownValueDic:(NSDictionary *)unkownValueDic
{
    if ([key isEqualToString:@"comments"]) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:unkownValueDic.count];
        [unkownValueDic enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *top) {
            LPNewsCommentItem *item = [LPNewsCommentItem ty_ModelWithDictonary:obj];
            dic[key] = item;
        }];
        return [dic copy];
    }
    return unkownValueDic;
}

@end

@implementation LPNewsCommentItem

+ (NSDictionary *)modelClassInArrayOrDictonary
{
    return @{@"user":[LPNewsCommentUser class]};
}

@end


@implementation LPNewsCommentUser

@end