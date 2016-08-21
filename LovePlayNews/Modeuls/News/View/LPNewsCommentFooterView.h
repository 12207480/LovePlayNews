//
//  LPNewsCommentFooterView.h
//  LovePlayNews
//
//  Created by tanyang on 16/8/20.
//  Copyright © 2016年 tany. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LPNewsCommentFooterView : UITableViewHeaderFooterView

@property (nonatomic, strong) NSString *title;

@property (nonatomic, copy) void (^clickedHandle)(void);

@end
