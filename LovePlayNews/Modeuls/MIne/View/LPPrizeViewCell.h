//
//  LPPrizeViewCell.h
//  LovePlayNews
//
//  Created by tany on 16/9/6.
//  Copyright © 2016年 tany. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LPTableViewItem.h"

@interface LPPrizeViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *leftView;
@property (weak, nonatomic) IBOutlet UILabel *leftTitleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *leftImageView;

@property (weak, nonatomic) IBOutlet UIView *rightView;
@property (weak, nonatomic) IBOutlet UILabel *rightTitleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *rightImageView;

@property (nonatomic, copy) void (^leftSelectedHandler)();
@property (nonatomic, copy) void (^rightSelectedHandler)();

@property (nonatomic, strong) LPTableViewItem *leftItem;

@property (nonatomic, strong) LPTableViewItem *rightItem;

@end
