//
//  NSObject+TYJSONModel.m
//  TYJSONModelDemo
//
//  Created by tany on 16/4/6.
//  Copyright © 2016年 tany. All rights reserved.
//

#import "NSObject+TYJSONModel.h"
#import "TYClassInfo.h"
#import <objc/message.h>


@implementation NSObject (TYJSONModel)

#pragma mark - json to model

+ (instancetype)ty_ModelWithJSON:(id)json
{
    if (!json) {
        return nil;
    }
    
    NSDictionary *dic = nil;
    NSData *jsonData = nil;
    if ([json isKindOfClass:[NSDictionary class]]) {
        dic = json;
    } else if ([json isKindOfClass:[NSString class]]) {
        jsonData = [(NSString *)json dataUsingEncoding : NSUTF8StringEncoding];
    } else if ([json isKindOfClass:[NSData class]]) {
        jsonData = json;
    }
    if (jsonData) {
        // data to json
        dic = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:NULL];
        if (![dic isKindOfClass:[NSDictionary class]])
            dic = nil;
    }
    
   return [self ty_ModelWithDictonary:dic];
}

// dictonary to model
+ (instancetype)ty_ModelWithDictonary:(NSDictionary *)dic
{
    if (!dic) {
        return nil;
    }
    
    NSObject *model = [[[self class]alloc]init];
    
    // dictonary to model
    [model ty_SetModelWithDictonary:dic];
    
    return model;
}

// dictonary to model
- (void)ty_SetModelWithDictonary:(NSDictionary *)dic
{
    if (!dic || ![dic isKindOfClass:[NSDictionary class]] || dic.count == 0) {
        return;
    }
    
    // 获取 当前类信息
    TYClassInfo *classInfo = [[TYClassInfo alloc]initWithClass:object_getClass(self)];
    
    // model in array or dictonary 映射
     NSDictionary *modelClassDic = nil;
    if ([[self class] respondsToSelector:@selector(modelClassInArrayOrDictonary)]) {
        modelClassDic = [[self class] modelClassInArrayOrDictonary];
    }
    
    // 属性 映射
    NSDictionary *propertyMapper = nil;
    if ([[self class] respondsToSelector:@selector(modelPropertyMapper)]) {
        propertyMapper = [[self class] modelPropertyMapper];
    }
    
    // 忽略 某些属性
    NSArray *ignoreProperties = nil;
    if ([[self class] respondsToSelector:@selector(ignoreModelProperties)]) {
        ignoreProperties = [[self class] ignoreModelProperties];
    }
    
    // 遍历当前类所有属性
    [classInfo.propertyInfo enumerateKeysAndObjectsUsingBlock:^(NSString *key, TYPropertyInfo *propertyInfo, BOOL * stop) {
        
        BOOL isIgnoreProperty = NO;
        id value = nil;
        
        if (ignoreProperties) {
            // 是否忽略这个属性
            isIgnoreProperty = [ignoreProperties containsObject:key];
        }
        
        if (!isIgnoreProperty) {
            NSString *maperKey = nil;   //映射key
            if (propertyMapper) {
                maperKey = [propertyMapper objectForKey:key];
            }
            
            // 根据属性名key 获取 字典里的value
            value = [dic objectForKey:maperKey ? maperKey : key];
        }

        if (!isIgnoreProperty && value) {
            // 如果value有值
            if ([value isKindOfClass:[NSArray class]]) {
                // 校验 property 是否 数组类型
                if ([propertyInfo.typeClass isSubclassOfClass:[NSArray class]]) {
                    Class class = nil;
                    if (modelClassDic) {
                        // 数组里是否包含模型
                        class = [modelClassDic objectForKey:key];
                    }
                    if (class) {
                        // 包含 就调用数组的 转模型方法
                        value = [(NSArray *)value ty_ModelArrayWithClass:class];
                    }else if ([self respondsToSelector:@selector(shouldCustomUnkownValueWithKey:)] && [self shouldCustomUnkownValueWithKey:key] && [self respondsToSelector:@selector(customValueWithKey:unkownValueArray:)]) {
                        // 自定义处理未知value
                        value = [self customValueWithKey:key unkownValueArray:value];
                    }
                }else {
                    // property 不是数组类型 返回数据有误
                    value = nil;
                }
            }else if([value isKindOfClass:[NSDictionary class]]){
                // property 是否是自定义模型
                if (propertyInfo.isCustomFondation) {
                    // 字典 对应模型
                    value = [propertyInfo.typeClass ty_ModelWithDictonary:value];
                }else if ([propertyInfo.typeClass isSubclassOfClass:[NSDictionary class]]) {
                    // property 是 字典类型
                    Class class = nil;
                    if (modelClassDic) {
                        // 字典 里 是否包含模型
                        class = [modelClassDic objectForKey:key];
                    }
                    if (class) {
                        // 包含 就调用字典的 转模型方法
                        value = [(NSDictionary *)value ty_ModelDictionaryWithClass:class];
                    }else if ([self respondsToSelector:@selector(shouldCustomUnkownValueWithKey:)] && [self shouldCustomUnkownValueWithKey:key] && [self respondsToSelector:@selector(customValueWithKey:unkownValueDic:)]) {
                        // 自定义处理未知value
                        value = [self customValueWithKey:key unkownValueDic:value];
                    }
                }else {
                    // property 不是 字典类型 返回数据有误
                    value = nil;
                }
            }
        
            if ([value isEqual:[NSNull null]]) {
                // 去除 null
                value = nil;
            }
            
            if (propertyInfo.typeClass) {
                // 对象类型
                if ([propertyInfo.typeClass isSubclassOfClass:[NSString class]] && [value isKindOfClass:[NSNumber class]]) {
                    //  number 转 string
                    value = [(NSNumber *)value stringValue];
                }else if (propertyInfo.typeClass == [NSValue class] || propertyInfo.typeClass == [NSDate class]) {
                    // 不支持类型
                    value = nil;
                }
                // 调用生成的 setter 方法 设置值
                [self setPropertyWithModel:self value:value setter:propertyInfo.setter];
            }else if(value) {
                // 基本类型
                if ([value isKindOfClass:[NSString class]]) {
                    static NSNumberFormatter *s_numberFormatter;
                    static dispatch_once_t onceToken;
                    dispatch_once(&onceToken, ^{
                        // NSString 转 NSNumber Formatter
                        s_numberFormatter = [[NSNumberFormatter alloc]init];
                    });
                    // string 转 number
                    value = [s_numberFormatter numberFromString:value];
                }
                // kvc 设置基本类型的值
                [self setValue:value forKey:key];
            }
        }
    }];
}

// model to dictonary
- (NSDictionary *)ty_ModelToDictonary
{
    if ([self isKindOfClass:[NSArray class]]) {
        return nil;
    }
    
    // 属性 映射
    NSDictionary *propertyMapper = nil;
    if ([[self class] respondsToSelector:@selector(modelPropertyMapper)]) {
        propertyMapper = [[self class] modelPropertyMapper];
    }
    
    // 忽略 某些属性
    NSArray *ignoreProperties = nil;
    if ([[self class] respondsToSelector:@selector(ignoreModelProperties)]) {
        ignoreProperties = [[self class] ignoreModelProperties];
    }
    
    // 获取 当前类信息
    TYClassInfo *classInfo = [[TYClassInfo alloc]initWithClass:object_getClass(self)];
    // 字典
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:classInfo.propertyInfo.count];
    
    [classInfo.propertyInfo enumerateKeysAndObjectsUsingBlock:^(NSString *key, TYPropertyInfo *propertyInfo, BOOL * stop) {
        
        BOOL isIgnoreProperty = NO;
        id value = nil;
        
        if (ignoreProperties) {
            // 是否忽略这个属性
            isIgnoreProperty = [ignoreProperties containsObject:key];
        }
        
        if (!isIgnoreProperty) {
            if (propertyInfo.typeClass) {
                // 对象类型 调用生成的 getter 方法 获取值
                value = [self propertyValueWithModel:self getter:propertyInfo.getter];
            }else {
                // 基本类型 使用kvc 获取值
                value = [self valueForKey:key];
            }
        }
        
        if (!isIgnoreProperty && value) {
            // 如果有值
            if ([value isKindOfClass:[NSArray class]]) {
                // 如果值是数组（可能包含模型） 调用model数组转dic数组方法
                value = [(NSArray *)value ty_ModelArrayToDicArray];
            }else if ([value isKindOfClass:[NSDictionary class]]) {
                // 如果值是字典（可能包含模型） 调用字典 model转dic方法
                value = [(NSDictionary *)value ty_ModelDictionaryToDictionary];
            }else if (propertyInfo.typeClass && propertyInfo.isCustomFondation) {
                value = [value ty_ModelToDictonary];
            }
            
            if (value) {
                NSString *maperKey = nil;
                if (propertyMapper) {
                    //映射key
                    maperKey = [propertyMapper objectForKey:key];
                }
                // 添加到字典
                dic[maperKey ? maperKey : key] = value;
            }

        }
        
    }];
    
    return [dic copy];
}

// dic array to model array
+ (NSArray *)ty_ModelArrayWithDictionaryArray:(NSArray *)dicArray
{
    return [dicArray ty_ModelArrayWithClass:[self class]];
}

#pragma mark - model to json
// model to json
- (id)ty_ModelToJSONObject
{
    if ([self isKindOfClass:[NSArray class]]) {
        // 如果是数组
        return [(NSArray *)self ty_ModelArrayToDicArray];
    }
    
    return [self ty_ModelToDictonary];
}

- (NSData *)ty_ModelToJSONData
{
    id jsonObject = [self ty_ModelToJSONObject];
    if (!jsonObject) return nil;
    return [NSJSONSerialization dataWithJSONObject:jsonObject options:0 error:NULL];
}

- (NSString *)ty_ModelToJSONString
{
    NSData *jsonData = [self ty_ModelToJSONData];
    if (jsonData.length == 0) return nil;
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

// model array to dic array
+ (NSArray *)ty_DictionaryArrayWithModelArray:(NSArray *)dicArray
{
    return [dicArray ty_ModelArrayToDicArray];
}

#pragma mark - encode decode
// encode
- (void)ty_EncodeWithCoder:(NSCoder *)aCoder
{
    TYClassInfo *classInfo = [[TYClassInfo alloc]initWithClass:object_getClass(self)];
    
    [classInfo.propertyInfo enumerateKeysAndObjectsUsingBlock:^(NSString *key, TYPropertyInfo *propertyInfo, BOOL * stop) {
        
        id value = nil;
        
        if (propertyInfo.typeClass) {
            value = [self propertyValueWithModel:self getter:propertyInfo.getter];

        }else {
            value = [self valueForKey:key];
        }
        
        if (value) {
            [aCoder encodeObject:value forKey:key];
        }
    }];
}

// decode
- (instancetype)ty_InitWithCoder:(NSCoder *)aDecoder
{
    if ([self init]) {
        TYClassInfo *classInfo = [[TYClassInfo alloc]initWithClass:object_getClass(self)];
        
        [classInfo.propertyInfo enumerateKeysAndObjectsUsingBlock:^(NSString *key, TYPropertyInfo *propertyInfo, BOOL * stop) {
            
            id value = [aDecoder decodeObjectForKey:key];
            
            if (value) {
                if (propertyInfo.typeClass) {
                    [self setPropertyWithModel:self value:value setter:propertyInfo.setter];
                }else {
                    [self setValue:value forKey:key];
                }
            }
        }];
    }
    return self;
}

#pragma mark -  set get Property

// set Property
- (void)setPropertyWithModel:(id)model value:(id)value setter:(SEL)setter
{
    if (!setter) {
        return;
    }
    ((void (*)(id, SEL, id))(void *) objc_msgSend)((id)model, setter, value);
}

// get Property
- (id)propertyValueWithModel:(id)model getter:(SEL)getter
{
    if (!getter) {
        return nil;
    }
    return ((id (*)(id, SEL))(void *) objc_msgSend)((id)model,getter);
}

@end

@implementation NSArray (TYJSONModel)

// 数组 to model 数组
- (NSArray *)ty_ModelArrayWithClass:(Class)class
{
    if (!class) {
        return self;
    }
    NSMutableArray *modelArray = [NSMutableArray array];
    // 遍历数组
    for (id value in self) {
        
        if ([value isKindOfClass:[NSDictionary class]]) {
            // value是字典 则 字典转模型
            NSObject *obj = [class ty_ModelWithDictonary:value];
            if (obj) {
                [modelArray addObject:obj];
            }
        }else if ([value isKindOfClass:[NSString class]]) {
            // value 是 NSString
            [modelArray addObject:value];
        }
    }
    return [modelArray copy];
}

//  model 数组 to 数组
- (NSArray *)ty_ModelArrayToDicArray
{
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:self.count];
    // 遍历数组
    for (id obj in self) {
        if (![TYPropertyInfo isClassFromFoundation:[obj class]]) {
            // obj 是 model 则 model 转 字典
            NSDictionary *dic = [obj ty_ModelToDictonary];
            if (dic) {
                [array addObject:dic];
            }
        }else {
            [array addObject:obj];
        }
    }
   return [array copy];
}

@end

@implementation NSDictionary (TYJSONModel)

// 字典 to model 字典
- (NSDictionary *)ty_ModelDictionaryWithClass:(Class)class
{
    if (!class) {
        return self;
    }
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    // 遍历字典
    [self enumerateKeysAndObjectsUsingBlock:^(NSString *key, id obj, BOOL * stop) {
        if ([key isKindOfClass:[NSString class]]) {
            // 字典包含 obj字典 转 model
            NSObject *value = [class ty_ModelWithDictonary:obj];
            if (value) {
                dic[key] = value;
            }
        }
    }];
    return [dic copy];
    
}

// model 字典 to 字典
- (NSDictionary *)ty_ModelDictionaryToDictionary
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:self.count];
    // 遍历字典
    [self enumerateKeysAndObjectsUsingBlock:^(NSString *key, id obj, BOOL * stop) {
        if (![TYPropertyInfo isClassFromFoundation:[obj class]]) {
            // obj 是 模型 则 model to dic
            NSDictionary *objDic = [obj ty_ModelToDictonary];
            if (objDic) {
                dic[key] = objDic;
            }
        }else {
            dic[key] = obj;
        }
    }];
    return [dic copy];
}

@end

