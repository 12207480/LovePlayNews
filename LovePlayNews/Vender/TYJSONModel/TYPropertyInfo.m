//
//  TYPropertyInfo.m
//  TYJSONModelDemo
//
//  Created by tany on 16/4/6.
//  Copyright © 2016年 tany. All rights reserved.
//

#import "TYPropertyInfo.h"
#import <objc/runtime.h>

@implementation TYPropertyInfo

- (instancetype)initWithProperty:(objc_property_t)property
{
    if (!property) {
        return nil;
    }
    
    if (self = [super init]) {
        
        //_property = property;
        // 获取属性名
        const char *cPropertyName = property_getName(property);
        if (cPropertyName) {
             _propertyName = [NSString stringWithUTF8String:cPropertyName];
        }
        
        BOOL readOnlyProperty = NO;
        unsigned int attrCount;
        // 获取属性的属性list
        objc_property_attribute_t *attrs = property_copyAttributeList(property, &attrCount);
        for (unsigned int idx = 0; idx < attrCount; ++idx) {
            switch (attrs[idx].name[0]) {
                case 'T':   // 属性
                    if (attrs[idx].name[0] == 'T') {
                        size_t len = strlen(attrs[idx].value);
                        if (len>3) {
                            char name[len - 2];
                            name[len - 3] = '\0';
                            memcpy(name, attrs[idx].value + 2, len - 3);
                            // 获取 属性类型名 （基本类型 _typeClass = ni ）
                            _typeClass = objc_getClass(name);
                        }
                    }
                    break;
                case 'R':
                    readOnlyProperty = YES;
                    break;
                case 'G':   // 自定义getter方法
                    if (attrs[idx].value) {
                        _getter = NSSelectorFromString([NSString stringWithUTF8String:attrs[idx].value]);
                    }
                    break;
                case 'S':   // 自定义setter方法
                    if (attrs[idx].value) {
                        _setter = NSSelectorFromString([NSString stringWithUTF8String:attrs[idx].value]);
                    }
                    break;
                    
                default:
                    break;
            }
        }
        
        if (attrs) {
            free(attrs);
        }
        
        if (_typeClass) {
            // 判断是否自定义对象类型
            _isCustomFondation = ![[self class] isClassFromFoundation:_typeClass];
        }
        
        if (_typeClass && _propertyName.length > 0) {
            // 如果是对象类型 生成 getter setter 方法
            if (!_getter) {
                _getter = NSSelectorFromString(_propertyName);
            }
            if (!_setter && !readOnlyProperty) {
                _setter = NSSelectorFromString([NSString stringWithFormat:@"set%@%@:", [_propertyName substringToIndex:1].uppercaseString, [_propertyName substringFromIndex:1]]);
            }
        }
        
    }
    return self;
}

// 是否是Foundation对象类型
+ (BOOL)isClassFromFoundation:(Class)class
{
    if (class == [NSString class] || class == [NSObject class])
        return YES;
    
    static NSArray *s_foundations;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        s_foundations = @[[NSURL class],
                          [NSDate class],
                          [NSValue class],
                          [NSData class],
                          [NSError class],
                          [NSArray class],
                          [NSDictionary class],
                          [NSString class],
                          [NSAttributedString class]];
    });
    
    BOOL result = NO;
    for (Class foundationClass in s_foundations) {
        if ([class isSubclassOfClass:foundationClass]) {
            result = YES;
            break;
        }
    }
    
    return result;
}

@end
