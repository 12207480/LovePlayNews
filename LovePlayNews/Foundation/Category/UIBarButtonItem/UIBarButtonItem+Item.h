//
//  UIBarButtonItem+TY_Item.h
//  TYFoundationDemo
//
//  Created by tanyang on 15/12/9.
//  Copyright © 2015年 tanyang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (TY_Item)

+ (UIBarButtonItem *)itemWithImageName:(NSString *)imageName target:(id)target action:(SEL)action;

+ (UIBarButtonItem *)itemWithImageName:(NSString *)imageName highlightImageName:(NSString *)highlightImageName target:(id)target action:(SEL)action;

+ (UIBarButtonItem *)itemWithImageName:(NSString *)imageName highlightImageName:(NSString *)highlightImageName selectedImageName:(NSString *)selectedImageName target:(id)target action:(SEL)action;

+ (NSArray *)itemWithImageName:(NSString *)imageName offsetX:(CGFloat)offsetX target:(id)target action:(SEL)action;

+ (NSArray *)itemWithImageName:(NSString *)imageName highlightImageName:(NSString *)highlightImageName offsetX:(CGFloat)offsetX target:(id)target action:(SEL)action;

+ (NSArray *)itemWithImageName:(NSString *)imageName highlightImageName:(NSString *)highlightImageName selectedImageName:(NSString *)selectedImageName offsetX:(CGFloat)offsetX target:(id)target action:(SEL)action;

@end
