//
//  TYGifAnimatorView.m
//  TYRefreshDemo
//
//  Created by tany on 16/10/13.
//  Copyright © 2016年 tany. All rights reserved.
//

#import "TYGifAnimatorView.h"

#define kImageViewCenterOffsetX 20
#define kTitleLabelLeftEdging 10

@interface TYGifAnimatorView ()

// UI
@property (nonatomic, weak) UILabel *titleLabel;

@property (nonatomic, weak) UILabel *messageLabel;

@property (nonatomic, weak) UIImageView *imageView;

// Data
@property (nonatomic, strong) NSMutableDictionary *titleDic;

@property (nonatomic, strong) NSMutableDictionary *gifImageDic;

@end

@implementation TYGifAnimatorView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        _titleLabelLeftEdging = kTitleLabelLeftEdging;
        _imageCenterOffsetX = kImageViewCenterOffsetX;
        _animationDuration = 0.25;
        
        [self addTitleLabel];
        
        [self addMessageLabel];
        
        [self addImageView];
    }
    return self;
}

- (instancetype)initWithHeight:(CGFloat)height
{
    return [self initWithFrame:CGRectMake(0, 0, 0, height)];
}

- (void)addTitleLabel
{
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.font = [UIFont systemFontOfSize:14];
    titleLabel.textColor = [UIColor colorWithRed:136/255.0 green:136/255.0 blue:136/255.0 alpha:1.0];
    [self addSubview:titleLabel];
    _titleLabel = titleLabel;
}

- (void)addMessageLabel
{
    UILabel *messageLabel = [[UILabel alloc]init];
    messageLabel.font = [UIFont systemFontOfSize:14];
    messageLabel.textColor = [UIColor colorWithRed:136/255.0 green:136/255.0 blue:136/255.0 alpha:1.0];
    messageLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:messageLabel];
    _messageLabel = messageLabel;
}

- (void)addImageView
{
    UIImageView *imageView = [[UIImageView alloc]init];
    imageView.image = [UIImage imageNamed:@"refresh_arrow_down"];
    [self addSubview:imageView];
    _imageView = imageView;
}

#pragma mark - gettter

- (NSMutableDictionary *)titleDic
{
    if (!_titleDic) {
        _titleDic = [NSMutableDictionary dictionary];
    }
    return _titleDic;
}

- (NSMutableDictionary *)gifImageDic
{
    if (!_gifImageDic) {
        _gifImageDic = [NSMutableDictionary dictionary];
    }
    return _gifImageDic;
}

#pragma mark - public

- (void)setTitle:(NSString *)title forState:(TYRefreshState)state
{
    [self.titleDic setObject:title ? title : @"" forKey:@(state)];
}

- (NSString *)titleForState:(TYRefreshState)state
{
    return [self.titleDic objectForKey:@(state)];
}

- (void)setGifImages:(NSArray *)gifImages forState:(TYRefreshState)state
{
     [self.gifImageDic setObject:gifImages forKey:@(state)];
}

- (NSArray *)gifImagesForState:(TYRefreshState)state
{
    return [self.gifImageDic objectForKey:@(state)];
}

#pragma mark - - (void)configureRefreshTitleWithType:(TYRefreshType)type

- (void)configureRefreshTitleWithType:(TYRefreshType)type
{
    // 默认
    [self setTitle:type==TYRefreshTypeHeader ? @"下拉刷新" : @"上拉刷新" forState:TYRefreshStateNormal];
    [self setTitle:type==TYRefreshTypeHeader ? @"下拉刷新" : @"上拉刷新" forState:TYRefreshStatePulling];
    [self setTitle:@"加载中..." forState:TYRefreshStateLoading];
    [self setTitle: @"松开刷新" forState:TYRefreshStateRelease];
    [self setTitle: @"加载失败" forState:TYRefreshStateError];
    [self setTitle: @"没有更多了" forState:TYRefreshStateNoMore];
}

- (void)configureRefreshGifImages
{
    
}

#pragma mark - TYRefreshAnimator

- (void)refreshViewDidPrepareRefresh:(TYRefreshView *)refreshView
{
    if (_titleDic.count == 0) {
        [self configureRefreshTitleWithType:refreshView.type];
    }
    
    if (_gifImageDic.count == 0) {
        [self configureRefreshGifImages];
    }
}

- (void)refreshViewDidBeginRefresh:(TYRefreshView *)refreshView
{
    [_imageView startAnimating];
}

- (void)refreshViewDidEndRefresh:(TYRefreshView *)refreshView
{
    [_imageView stopAnimating];
}

- (void)refreshView:(TYRefreshView *)refreshView didChangeFromState:(TYRefreshState)fromState toState:(TYRefreshState)toState
{
    if (toState == TYRefreshStateNormal || toState == TYRefreshStateNoMore || toState == TYRefreshStateError) {
        _titleLabel.hidden = YES;
        _imageView.hidden = YES;
        _messageLabel.hidden = NO;
        _messageLabel.text = [self titleForState:toState];
    }else {
        _titleLabel.hidden = _titleLabelHidden;
        _imageView.hidden = NO;
        _messageLabel.hidden = YES;
        _titleLabel.text = [self titleForState:toState];
    }

    switch (toState) {
        case TYRefreshStateLoading:
        {
            if (_imageView.isAnimating) {
                [_imageView stopAnimating];
            }
            NSArray *loadingImages = [self gifImagesForState:toState];
            if (!loadingImages || loadingImages.count == 0) {
                return;
            }
            if (loadingImages.count == 1) {
                _imageView.image = loadingImages.firstObject;
            }else {
                _imageView.animationImages = loadingImages;
                _imageView.animationDuration = _animationDuration;
            }
        }
            break;
        case TYRefreshStateNormal:
        {
            if (_imageView.isAnimating) {
                [_imageView stopAnimating];
            }
            NSArray *pullingImages = [self gifImagesForState:TYRefreshStatePulling];
            if (pullingImages.count > 0) {
                _imageView.image = pullingImages.firstObject;
            }
        }
            break;
        default:
            break;
    }
}

- (void)refreshView:(TYRefreshView *)refreshView didChangeProgress:(CGFloat)progress
{
    if (_imageView.isAnimating) {
        [_imageView stopAnimating];
    }
    NSArray *pullingImages = [self gifImagesForState:TYRefreshStatePulling];
    if (!pullingImages || pullingImages.count == 0) {
        return;
    }
    NSInteger index = pullingImages.count * progress;
    _imageView.image = pullingImages[MIN(index, pullingImages.count - 1)];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    UIImage *gifImage = [[_gifImageDic objectForKey:@(TYRefreshStateLoading)] firstObject];
    if (!gifImage) {
        return;
    }
    _imageView.frame = CGRectMake(0, 0, gifImage.size.width, gifImage.size.height);
    CGFloat imageCenterX = _titleLabelHidden ? CGRectGetWidth(self.frame)/2 : CGRectGetWidth(self.frame)/2 - _imageCenterOffsetX - gifImage.size.width/2 ;
    _imageView.center = CGPointMake(imageCenterX , CGRectGetHeight(self.frame)/2);
    
    _titleLabel.frame = CGRectMake(CGRectGetMaxX(_imageView.frame)+_titleLabelLeftEdging, 0, CGRectGetWidth(self.frame) - CGRectGetMaxX(_imageView.frame) - _titleLabelLeftEdging , CGRectGetHeight(self.frame));
    
    _messageLabel.frame = self.bounds;
}

@end
