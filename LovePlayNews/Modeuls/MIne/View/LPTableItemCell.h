//
//  LPTableItemCell.h
//  LovePlayNews
//
//  Created by tany on 16/9/6.
//  Copyright © 2016年 tany. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LPTableViewItem.h"

@interface LPTableItemCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (nonatomic, strong) LPTableViewItem *item;

@end
