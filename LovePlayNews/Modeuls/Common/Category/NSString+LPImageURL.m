//
//  NSString+LPImageURL.m
//  LovePlayNews
//
//  Created by tany on 16/9/2.
//  Copyright © 2016年 tany. All rights reserved.
//

#import "NSString+LPImageURL.h"

@implementation NSString (LPImageURL)

- (NSString *)appropriateImageURLSting
{
    return [NSString stringWithFormat:@"%@?w=750&h=20000&quality=75",self];
}

- (NSURL *)appropriateImageURL
{
    return [NSURL URLWithString:[self appropriateImageURLSting]];
}

@end
