//
//  LPNewsCommonModel.m
//  LovePlayNews
//
//  Created by tany on 16/8/10.
//  Copyright © 2016年 tany. All rights reserved.
//

#import "LPNewsCommonModel.h"
#import "TYJSONModel.h"

@implementation LPNewsCommonModel

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
            dic[key] = [LPNewsCommonItem ty_ModelWithDictonary:obj];
        }];
        return [dic copy];
    }
    return unkownValueDic;
}

@end

@implementation LPNewsCommonItem

+ (NSDictionary *)modelClassInArrayOrDictonary
{
    return @{@"user":[LPNewsCommonUser class]};
}

@end


@implementation LPNewsCommonUser

@end