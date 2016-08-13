//
//  LPWebCellNode.h
//  LovePlayNews
//
//  Created by tanyang on 16/8/6.
//  Copyright © 2016年 tany. All rights reserved.
//

#import <AsyncDisplayKit/AsyncDisplayKit.h>

@interface LPWebCellNode : ASCellNode

@property (nonatomic, copy) void (^webViewDidFinishLoad)(void);

- (instancetype)initWithURL:(NSURL *)URL;

- (instancetype)initWithHtmlBody:(NSString *)htmlBody;

@end
