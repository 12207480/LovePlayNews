//
//  TYClassInfo.h
//  TYJSONModelDemo
//
//  Created by tany on 16/4/6.
//  Copyright © 2016年 tany. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TYPropertyInfo.h"

@interface TYClassInfo : NSObject

@property(nonatomic,strong, readonly) NSDictionary *propertyInfo;// 属性字典<NSString *,TYPropertyInfo *>
@property(nonatomic,assign, readonly) Class cls; // class

- (instancetype)initWithClass:(Class )cls;

@end
