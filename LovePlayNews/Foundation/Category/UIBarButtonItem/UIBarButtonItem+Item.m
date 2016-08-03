//
//  UIBarButtonItem+TY_Item.m
//  TYFoundationDemo
//
//  Created by tanyang on 15/12/9.
//  Copyright © 2015年 tanyang. All rights reserved.
//

#import "UIBarButtonItem+Item.h"

@implementation UIBarButtonItem (TY_Item)

+ (UIBarButtonItem *)itemWithImageName:(NSString *)imageName target:(id)target action:(SEL)action
{
    return [self itemWithImageName:imageName highlightImageName:nil selectedImageName:nil target:target action:action];
}

+ (UIBarButtonItem *)itemWithImageName:(NSString *)imageName highlightImageName:(NSString *)highlightImageName target:(id)target action:(SEL)action
{
    return [self itemWithImageName:imageName highlightImageName:highlightImageName selectedImageName:nil target:target action:action];
}

+ (UIBarButtonItem *)itemWithImageName:(NSString *)imageName highlightImageName:(NSString *)highlightImageName selectedImageName:(NSString *)selectedImageName target:(id)target action:(SEL)action
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    if (imageName) {
        [button setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    }
    
    if (highlightImageName) {
        [button setBackgroundImage:[UIImage imageNamed:highlightImageName] forState:UIControlStateHighlighted];
    }else {
        button.adjustsImageWhenHighlighted = NO;
    }
    
    if (selectedImageName) {
        [button setBackgroundImage:[UIImage imageNamed:highlightImageName] forState:UIControlStateSelected];
    }
    
    button.frame = (CGRect){CGPointZero,button.currentBackgroundImage.size};
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return [[UIBarButtonItem alloc]initWithCustomView:button];
}


+ (NSArray *)itemWithImageName:(NSString *)imageName offsetX:(CGFloat)offsetX target:(id)target action:(SEL)action
{
    return [self itemWithImageName:imageName highlightImageName:nil selectedImageName:nil offsetX:offsetX target:target action:action];
}

+ (NSArray *)itemWithImageName:(NSString *)imageName highlightImageName:(NSString *)highlightImageName offsetX:(CGFloat)offsetX target:(id)target action:(SEL)action
{
    return [self itemWithImageName:imageName highlightImageName:highlightImageName selectedImageName:nil offsetX:offsetX target:target action:action];
}


+ (NSArray *)itemWithImageName:(NSString *)imageName highlightImageName:(NSString *)highlightImageName selectedImageName:(NSString *)selectedImageName offsetX:(CGFloat)offsetX target:(id)target action:(SEL)action
{
    UIBarButtonItem *flexBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:NULL];
    flexBarButtonItem.width = - offsetX;
    
    UIBarButtonItem *item = [UIBarButtonItem itemWithImageName:imageName highlightImageName:highlightImageName selectedImageName:selectedImageName target:target action:action];
    
    return @[flexBarButtonItem,item];
}

@end
