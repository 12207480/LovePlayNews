//
//  LPDiscuzPostCell.h
//  LovePlayNews
//
//  Created by tanyang on 2016/9/9.
//  Copyright © 2016年 tany. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LPDiscuzDetailModel.h"

@interface LPDiscuzPostCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *floorLabel;

- (void)setPost:(LPDiscuzPost *)post floor:(NSInteger)floor;

@end
