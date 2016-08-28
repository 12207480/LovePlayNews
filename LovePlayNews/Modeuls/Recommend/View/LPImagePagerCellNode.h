//
//  LPImagePagerNode.h
//  LovePlayNews
//
//  Created by tanyang on 16/8/27.
//  Copyright © 2016年 tany. All rights reserved.
//

#import <AsyncDisplayKit/AsyncDisplayKit.h>
#import "LPTopicImageInfo.h"

@interface LPImagePagerCellNode : ASCellNode

@property (nonatomic, copy) void(^didSelectImageInfoHandle)(LPTopicImageInfo *);

- (instancetype)initWithImageInfos:(NSArray *)imageInfos;

@end
