//
//  LPNewsFavorCellNode.h
//  LovePlayNews
//
//  Created by tany on 16/8/16.
//  Copyright © 2016年 tany. All rights reserved.
//

#import <AsyncDisplayKit/AsyncDisplayKit.h>
#import "LPNewsDetailModel.h"

@interface LPNewsFavorCellNode : ASCellNode

- (instancetype)initWithFavors:(LPNewsFavorInfo *)favorInfo;

@end
