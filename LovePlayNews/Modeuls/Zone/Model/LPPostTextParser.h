//
//  LPPostTextParser.h
//  LovePlayNews
//
//  Created by tanyang on 2016/9/9.
//  Copyright © 2016年 tany. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <TYTextContainer.h>

@interface LPPostTextParser : NSObject

+ (NSString *)replaceXMLLabelWithText:(NSString *)text;

+ (TYTextContainer *)parserPostText:(NSString *)text;

@end
