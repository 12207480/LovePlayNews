//
//  LPTableViewItem.h
//  LovePlayNews
//
//  Created by tany on 16/9/6.
//  Copyright © 2016年 tany. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LPTableViewItem : NSObject

// 标题
@property (nonatomic, strong) NSString *title;

// 图标
@property (nonatomic, strong) NSString *icon;

@property (nonatomic, assign )NSInteger accessoryType;

// 点击cell 运行的控制器
@property (nonatomic, assign) Class destVcClass;

// 点击是否运行
@property (nonatomic, copy) BOOL (^shouldSelectedHandler)();
// 点击运行block
@property (nonatomic, copy) void (^selectedHandler)();

- (instancetype)initWithTitle:(NSString *)title icon:(NSString *)icon;

- (instancetype)initWithTitle:(NSString *)title;

@end
