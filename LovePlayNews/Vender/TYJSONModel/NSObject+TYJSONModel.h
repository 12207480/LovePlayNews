//
//  NSObject+TYJSONModel.h
//  TYJSONModelDemo
//
//  Created by tany on 16/4/6.
//  Copyright © 2016年 tany. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TYJSONModel <NSObject>

@optional

// 数组[value,value] 或 字典{key: value,key: value} value模型映射类型
+ (NSDictionary *)modelClassInArrayOrDictonary;

// 属性名 - key 映射
+ (NSDictionary *)modelPropertyMapper;

// 忽略某些属性
+ (NSArray *)ignoreModelProperties;

@end

@interface NSObject (TYJSONModel) <TYJSONModel>

// json to model
+ (instancetype)ty_ModelWithJSON:(id)json; // json: NSString,NSDictionary,NSData
+ (instancetype)ty_ModelWithDictonary:(NSDictionary *)dic;

- (void)ty_SetModelWithDictonary:(NSDictionary *)dic;

// model to json
- (id)ty_ModelToJSONObject; // array or dic
- (NSData *)ty_ModelToJSONData;
- (NSString *)ty_ModelToJSONString;
- (NSDictionary *)ty_ModelToDictonary;

// dic array to model array
+ (NSArray *)ty_modelArrayWithDictionaryArray:(NSArray *)dicArray;
// model array to dic array
+ (NSArray *)ty_dictionaryArrayWithModelArray:(NSArray *)dicArray;

// NSCoding
- (void)ty_EncodeWithCoder:(NSCoder *)aCoder;
- (instancetype)ty_InitWithCoder:(NSCoder *)aDecoder;

@end


@interface NSArray (TYJSONModel)

// to model array
- (NSArray *)ty_ModelArrayWithClass:(Class)cls;

// to dic array
- (NSArray *)ty_ModelArrayToDicArray;

@end

@interface NSDictionary (TYJSONModel)

// to model dictionary
- (NSDictionary *)ty_ModelDictionaryWithClass:(Class)cls;

// to dictionary
- (NSDictionary *)ty_ModelDictionaryToDictionary;

@end
