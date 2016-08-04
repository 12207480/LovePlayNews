//
//  TYClassInfo.m
//  TYJSONModelDemo
//
//  Created by tany on 16/4/6.
//  Copyright © 2016年 tany. All rights reserved.
//

#import "TYClassInfo.h"

static NSCache *s_classInfoCache;

@implementation TYClassInfo

- (instancetype)initWithClass:(Class )class
{
    if (!class) {
        return nil;
    }
    
    // 取缓存
    id cacheInfo = [self objectOnCacheForClass:class];
    if (cacheInfo) {
        return cacheInfo;
    }
    
    if (self = [super init]) {
        
        _cls = class;

        unsigned int propertyCount = 0;
        // 获取属性list
        objc_property_t *properties = class_copyPropertyList(_cls, &propertyCount);
        
        if (properties) {
            NSMutableDictionary *propertyInfo = [NSMutableDictionary dictionaryWithCapacity:propertyCount];
            
            for (unsigned int i = 0; i < propertyCount; i++) {
                // 生成属性对象
                TYPropertyInfo *info = [[TYPropertyInfo alloc] initWithProperty:properties[i]];
                if (info.propertyName)
                    // 添加到（属性名 - 属性对象）字典
                    propertyInfo[info.propertyName] = info;
            }
            
            free(properties);
            _propertyInfo = [propertyInfo copy];
        }
    }
    
    // 添加到缓存
    [self setObjectToCacheForClass:class];
    
    return  self;
}

- (id)objectOnCacheForClass:(Class)class
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // 设置 class 缓存
        s_classInfoCache = [[NSCache alloc]init];
        s_classInfoCache.totalCostLimit = 0.5*1024*1024;
        s_classInfoCache.countLimit = 50;
    });
    id cacheInfo = [s_classInfoCache objectForKey:class];
    return cacheInfo;
}

- (void)setObjectToCacheForClass:(Class)class
{
    [s_classInfoCache setObject:self forKey:class];
}

@end
