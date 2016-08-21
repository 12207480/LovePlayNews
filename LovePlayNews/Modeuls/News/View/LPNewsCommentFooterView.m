//
//  LPNewsCommentFooterView.m
//  LovePlayNews
//
//  Created by tanyang on 16/8/20.
//  Copyright © 2016年 tany. All rights reserved.
//

#import "LPNewsCommentFooterView.h"

@interface LPNewsCommentFooterView ()

@property (nonatomic, weak) UIButton *button;

@end

@implementation LPNewsCommentFooterView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        
        [self addTitleLabel];
    }
    return self;
}

- (void)addTitleLabel
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    button.titleLabel.textAlignment = NSTextAlignmentCenter;
    [button setTitleColor:RGB_255(218, 85, 107) forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonClikedAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
    _button = button;
}

- (void)setTitle:(NSString *)title
{
    _title = title;
    [_button setTitle:title forState:UIControlStateNormal];
}

- (void)buttonClikedAction
{
    if (_clickedHandle) {
        _clickedHandle();
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _button.frame = self.bounds;
}

@end
