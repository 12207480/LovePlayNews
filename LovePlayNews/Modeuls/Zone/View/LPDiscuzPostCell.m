//
//  LPDiscuzPostCell.m
//  LovePlayNews
//
//  Created by tanyang on 2016/9/9.
//  Copyright © 2016年 tany. All rights reserved.
//

#import "LPDiscuzPostCell.h"
#import <YYWebImage.h>

@implementation LPDiscuzPostCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
}

- (void)setPost:(LPDiscuzPost *)post floor:(NSInteger)floor
{
    [self.iconView setYy_imageURL:[NSURL URLWithString:@"http://uc.bbs.d.163.com/images/noavatar_middle.gif"]];
    self.nameLabel.text = post.author;
    self.timeLabel.text = [post.dateline stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@""];
    self.floorLabel.text = @(floor).stringValue;
    self.attributedLabel.textContainer = post.textContainer;
}


@end
