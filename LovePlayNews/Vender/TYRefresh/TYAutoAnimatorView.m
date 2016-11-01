//
//  TYAutoAnimatorView.m
//  TYRefreshDemo
//
//  Created by tany on 16/10/25.
//  Copyright © 2016年 tany. All rights reserved.
//

#import "TYAutoAnimatorView.h"

#define kImageViewCenterOffsetX 20
#define kTitleLabelLeftEdging 10

@interface TYAutoAnimatorView ()

// UI
@property (nonatomic, weak) UILabel *titleLabel;

@property (nonatomic, weak) UILabel *messageLabel;

@property (nonatomic, weak) UIActivityIndicatorView *indicatorView;

// Data
@property (nonatomic, strong) NSMutableDictionary *titleDic;

@property (nonatomic, strong) NSArray *loadingImages;

@end

@implementation TYAutoAnimatorView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        _imageCenterOffsetX = kImageViewCenterOffsetX;
        _titleLabelLeftEdging = kTitleLabelLeftEdging;
        _loadingAnimationDuration = 0.25;
        
        [self addTitleLabel];
        
        [self addMessageLabel];
        
        [self addImageView];
        
        [self addIndicatorView];
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
    [self addSubview:imageView];
    _imageView = imageView;
}

- (void)addIndicatorView
{
    UIActivityIndicatorView *indicatorView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    indicatorView.hidesWhenStopped = NO;
    [self addSubview:indicatorView];
    _indicatorView = indicatorView;
}

- (NSMutableDictionary *)titleDic
{
    if (!_titleDic) {
        _titleDic = [NSMutableDictionary dictionary];
    }
    return _titleDic;
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

- (void)setLoadingImages:(NSArray *)loadingImages
{
    _loadingImages = loadingImages;
}

#pragma mark - private

- (void)configureRefreshTitleWithType:(TYRefreshType)type
{
    // 默认
    [self setTitle: type==TYRefreshTypeHeader ? @"下拉自动加载" : @"上拉自动加载" forState:TYRefreshStateNormal];
    [self setTitle: @"加载中..." forState:TYRefreshStatePulling];
    [self setTitle: @"加载中..." forState:TYRefreshStateLoading];
    [self setTitle: @"加载中..." forState:TYRefreshStateRelease];
    [self setTitle: @"加载失败" forState:TYRefreshStateError];
    [self setTitle: @"没有更多了" forState:TYRefreshStateNoMore];
}

#pragma mark - TYRefreshAnimator

- (void)refreshViewDidPrepareRefresh:(TYRefreshView *)refreshView
{
    if (_titleDic.count == 0) {
        [self configureRefreshTitleWithType:refreshView.type];
    }
}

- (void)refreshView:(TYRefreshView *)refreshView didChangeFromState:(TYRefreshState)fromState toState:(TYRefreshState)toState
{
    _titleLabel.text = [self titleForState:toState];
    
    if (toState == TYRefreshStateNormal || toState == TYRefreshStateNoMore || toState == TYRefreshStateError) {
        _titleLabel.hidden = YES;
        _imageView.hidden = YES;
        _indicatorView.hidden = YES;
        _messageLabel.hidden = NO;
        _messageLabel.text = [self titleForState:toState];
    }else {
        _titleLabel.hidden = _titleLabelHidden;
        _imageView.hidden = _loadingImages.count <= 0;
        _indicatorView.hidden = !_imageView.hidden;
        _messageLabel.hidden = YES;
        _titleLabel.text = [self titleForState:toState];
    }
    
    switch (toState) {
        case TYRefreshStateLoading:
        {
            if (_imageView.isAnimating) {
                [_imageView stopAnimating];
            }
            if ( _loadingImages.count == 0) {
                return;
            }
            if (_loadingImages.count == 1) {
                _imageView.image = _loadingImages.firstObject;
            }else {
                _imageView.animationImages = _loadingImages;
                _imageView.animationDuration = _loadingAnimationDuration;
            }
        }
            break;
        case TYRefreshStateNormal:
        {
            if (_imageView.isAnimating) {
                [_imageView stopAnimating];
            }
            if ( _loadingImages.count == 0) {
                return;
            }
            _imageView.image = _loadingImages.firstObject;
        }
            break;
        default:
            break;
    }
}

- (void)refreshViewDidBeginRefresh:(TYRefreshView *)refreshView
{
    if (_loadingImages.count > 0) {
        [_imageView startAnimating];
    }else {
         [_indicatorView startAnimating];
    }
}

- (void)refreshViewDidEndRefresh:(TYRefreshView *)refreshView
{
    if (_loadingImages.count > 0) {
        [_imageView stopAnimating];
    }else {
        [_indicatorView stopAnimating];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect leftViewFrame = CGRectZero;
    if (_loadingImages.count > 0) {
        UIImage *gifImage = _loadingImages.firstObject;
        _imageView.frame = CGRectMake(0, 0, gifImage.size.width, gifImage.size.height);
        CGFloat imageCenterX = _titleLabel.hidden && _messageLabel.hidden ? CGRectGetWidth(self.frame)/2 : CGRectGetWidth(self.frame)/2 - _imageCenterOffsetX - gifImage.size.width/2;
        _imageView.center = CGPointMake(imageCenterX , CGRectGetHeight(self.frame)/2);
        leftViewFrame = _imageView.frame;
    }else {
        CGFloat imageWidth = MAX(CGRectGetWidth(_indicatorView.frame)/2, 20);
        _indicatorView.center = CGPointMake( _titleLabelHidden ? CGRectGetWidth(self.frame)/2 :CGRectGetWidth(self.frame)/2 - kImageViewCenterOffsetX - imageWidth , CGRectGetHeight(self.frame)/2);
        leftViewFrame = _indicatorView.frame;
    }

    _titleLabel.frame = CGRectMake(CGRectGetMaxX(leftViewFrame)+_titleLabelLeftEdging, 0, CGRectGetWidth(self.frame) - CGRectGetMaxX(leftViewFrame) - _titleLabelLeftEdging , CGRectGetHeight(self.frame));
    _messageLabel.frame = self.bounds;
}

@end
