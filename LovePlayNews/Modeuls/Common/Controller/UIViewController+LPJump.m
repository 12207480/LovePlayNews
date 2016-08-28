//
//  UIViewController+LPJump.m
//  LovePlayNews
//
//  Created by tanyang on 16/8/28.
//  Copyright © 2016年 tany. All rights reserved.
//

#import "UIViewController+LPJump.h"
#import "LPNewsDetailController.h"

@implementation UIViewController (LPJump)

- (void)gotoNewsDetailController:(NSString *)newsId
{
    LPNewsDetailController *detail = [[LPNewsDetailController alloc]init];
    detail.newsId = newsId;
    [self.navigationController pushViewController:detail animated:YES];
}

@end
