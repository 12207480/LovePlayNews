//
//  LPNavigationBarView.m
//  LovePlayNews
//
//  Created by tanyang on 16/8/20.
//  Copyright © 2016年 tany. All rights reserved.
//

#import "LPNavigationBarView.h"

@interface LPNavigationBarView ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation LPNavigationBarView

- (void)setTitle:(NSString *)title
{
    _title = title;
    _titleLabel.text = title;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
}

#pragma mark - action

- (IBAction)navBackAction:(id)sender
{
    if (_navBackHandle) {
        _navBackHandle();
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
