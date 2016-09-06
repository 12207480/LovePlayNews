//
//  LPPrizeViewCell.m
//  LovePlayNews
//
//  Created by tany on 16/9/6.
//  Copyright © 2016年 tany. All rights reserved.
//

#import "LPPrizeViewCell.h"

@implementation LPPrizeViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setLeftItem:(LPTableViewItem *)leftItem
{
    _leftItem = leftItem;
    self.leftView.hidden = !leftItem;
    
    if (!leftItem) {
        return;
    }
    
    self.leftImageView.image = [UIImage imageNamed:leftItem.icon];
    self.leftTitleLabel.text = leftItem.title;
}

- (void)setRightItem:(LPTableViewItem *)rightItem
{
    _rightItem = rightItem;
    self.rightView.hidden = !rightItem;
    if (!rightItem) {
        return;
    }

    self.rightImageView.image = [UIImage imageNamed:rightItem.icon];
    self.rightTitleLabel.text = rightItem.title;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)rightClickedAction:(id)sender {
    if (_rightItem && _rightItem.selectedHandler) {
        _rightItem.selectedHandler();
    }
}

- (IBAction)leftClickedAction:(id)sender {
    if (_leftItem && _leftItem.selectedHandler) {
        _leftItem.selectedHandler();
    }
}

@end
