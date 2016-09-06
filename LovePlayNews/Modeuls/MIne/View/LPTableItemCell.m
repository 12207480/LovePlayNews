//
//  LPTableItemCell.m
//  LovePlayNews
//
//  Created by tany on 16/9/6.
//  Copyright © 2016年 tany. All rights reserved.
//

#import "LPTableItemCell.h"

@implementation LPTableItemCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setItem:(LPTableViewItem *)item
{
    _item = item;
    self.titleLabel.text = item.title;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
