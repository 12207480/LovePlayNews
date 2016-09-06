//
//  LPTableViewItem.m
//  LovePlayNews
//
//  Created by tany on 16/9/6.
//  Copyright © 2016年 tany. All rights reserved.
//

#import "LPTableViewItem.h"

@implementation LPTableViewItem

- (instancetype)initWithTitle:(NSString *)title icon:(NSString *)icon
{
    if (self = [super init]) {
        _title = title;
        _icon = icon;
    }
    return self;
}

- (instancetype)initWithTitle:(NSString *)title
{
    if (self = [self initWithTitle:title icon:nil]) {
        
    }
    return self;
}

@end
