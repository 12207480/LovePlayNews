//
//  TYPropertyInfo.h
//  TYJSONModelDemo
//
//  Created by tany on 16/4/6.
//  Copyright © 2016年 tany. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

@interface TYPropertyInfo : NSObject

//@property (nonatomic, assign, readonly) objc_property_t property; // 属性

@property (nonatomic, strong, readonly) NSString *propertyName;  // 属性名

@property (nonatomic, assign, readonly) Class typeClass;      // 属性class类型 如果属性是基本类型为nil

@property (nonatomic, assign, readonly) BOOL isCustomFondation; // 是否自定义对象类型

@property (nonatomic, assign, readonly) SEL setter;       // 属性 setter 方法

@property (nonatomic, assign, readonly) SEL getter;       // 属性 getter 方法

- (instancetype)initWithProperty:(objc_property_t)property;

// 是否是Foundation对象类型
+ (BOOL)isClassFromFoundation:(Class)cls;

@end
