//
//  LPBannerViewCell.m
//  LovePlayNews
//
//  Created by tany on 2017/8/7.
//  Copyright © 2017年 tany. All rights reserved.
//

#import "LPBannerViewCell.h"

@implementation LPBannerViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addImageView];
    }
    return self;
}

- (void)addImageView {
    UIImageView *imageView = [[UIImageView alloc]init];
    [self addSubview:imageView];
    _imageView = imageView;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _imageView.frame = self.bounds;
}

@end
