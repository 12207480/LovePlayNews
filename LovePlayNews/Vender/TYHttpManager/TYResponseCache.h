//
//  TYResponseCache.h
//  TYHttpManagerDemo
//
//  Created by tany on 16/5/24.
//  Copyright © 2016年 tany. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TYResponseCache : NSObject

- (id <NSCoding>)objectForKey:(NSString *)key;

- (id <NSCoding>)objectForKey:(NSString *)key overdueDate:(NSDate *)overdueDate;

- (void)setObject:(id <NSCoding>)object forKey:(NSString *)key;

- (void)removeObjectForKey:(NSString *)key;

- (void)removeAllObjects;

- (void)trimToDate:(NSDate *)date;

@end
