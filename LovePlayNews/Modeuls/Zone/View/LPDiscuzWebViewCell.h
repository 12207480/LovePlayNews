//
//  LPDiscuzWebViewCell.h
//  LovePlayNews
//
//  Created by tanyang on 16/9/9.
//  Copyright © 2016年 tany. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kWebViewTopEdge 46

@interface LPDiscuzWebViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (nonatomic,strong) NSURL *URL;

@property (nonatomic,strong) NSString *htmlBody;

@property (nonatomic,assign, readonly) CGFloat webViewHeight;

@property (nonatomic, copy) void (^webViewDidFinishLoad)(CGFloat);

- (void)loadWebURL;

- (void)loadWebHtml;

@end
