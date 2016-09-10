//
//  LPPostTextParser.m
//  LovePlayNews
//
//  Created by tanyang on 2016/9/9.
//  Copyright © 2016年 tany. All rights reserved.
//

#import "LPPostTextParser.h"

@implementation LPPostTextParser

+ (NSString *)replaceXMLLabelWithText:(NSString *)text
{
    NSString *str = [text stringByReplacingOccurrencesOfString:@"<br />" withString:@"\n"];
    str = [str stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@" "];
    str = [str stringByReplacingOccurrencesOfString:@"&nbsp" withString:@" "];
    str = [str stringByReplacingOccurrencesOfString:@"<em>" withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@"</em>" withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@"\n\n" withString:@"\n"];
    str = [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    return str;
}

+ (TYTextContainer *)parserPostText:(NSString *)text
{
    TYTextContainer *textContainer = [[TYTextContainer alloc] init];
    textContainer.font = [UIFont systemFontOfSize:16];
    textContainer.textColor = RGB_255(34, 34, 34);
    textContainer.text = text;
    [textContainer addTextStorageArray:[self parseTextImageStorage:text]];
    [textContainer createTextContainerWithTextWidth:kScreenWidth-2*10];
    return textContainer;
}

+ (NSArray *)parseTextImageStorage:(NSString *)text
{
    if ([text rangeOfString:@"img"].location == NSNotFound && [text rangeOfString:@"IMG"].location == NSNotFound ) {
        return nil;
    }
    
    // regex
    NSString *regex_image = @"<(?i:img).+src=\"([^\"]+\\.(jpg|gif|bmp|bnp|png))\".*>";
    
    NSMutableArray *imageStorageArray = [NSMutableArray array];
    
    // 正则
    NSError *error;
    NSRegularExpression *regular = [NSRegularExpression regularExpressionWithPattern:regex_image
                            options:NSRegularExpressionCaseInsensitive
                            error:&error];
    // 对text进行匹配
    NSArray *matches = [regular matchesInString:text
                                        options:0
                                          range:NSMakeRange(0, text.length)];
    
    // 遍历匹配后的每一条记录
    for (NSTextCheckingResult *match in matches) {
        NSRange range = [match range];
        NSString *imageURL = match.numberOfRanges > 1 ? [text substringWithRange:[match rangeAtIndex:1]] : [text substringWithRange:range];
        
        TYImageStorage *imageStorage = [[TYImageStorage alloc]init];
        imageStorage.range = range;
        imageStorage.cacheImageOnMemory = YES;
        imageStorage.imageURL = [NSURL URLWithString:imageURL];
        imageStorage.size = CGSizeMake(32, 32);
        [imageStorageArray addObject:imageStorage];
    }
    
    return [imageStorageArray copy];
}

- (CGSize)sizeFitOriginSize:(CGSize)size byWidth:(CGFloat)width{
    if (size.width > width) {
        CGFloat scale = width/size.width;
        CGFloat height = size.height * scale;
        return CGSizeMake(width, height);
    }
    return CGSizeMake(size.width, size.height);
}

@end
