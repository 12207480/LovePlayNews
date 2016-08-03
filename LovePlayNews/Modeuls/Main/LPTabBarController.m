//
//  LPTabBarController.m
//  LovePlayNews
//
//  Created by tany on 16/8/1.
//  Copyright © 2016年 tany. All rights reserved.
//

#import "LPTabBarController.h"
#import "UITabBarController+AddChildVC.h"
#import "LPNavigationController.h"
#import "LPPagerViewController.h"
#import "UIImage+Color.h"
#import "ViewController.h"

@interface LPTabBarController ()

@end

@implementation LPTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self configureTabBar];
    
    [self configureChildViewConstrollers];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

- (void)configureTabBar
{
    self.tabBar.shadowImage = [UIImage imageNamed:@"tabbartop-line"];
    if (kIsIOS8Later) {
        [self.tabBar setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRed:237/255.0 green:239/255.0 blue:244/255.0 alpha:0.85]]];
        // blur效果
        UIVisualEffectView *visualEfView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
        visualEfView.frame = CGRectMake(0, -1, CGRectGetWidth(self.tabBar.frame), CGRectGetHeight(self.tabBar.frame)+1);
        visualEfView.alpha = 1.0;
        [self.tabBar insertSubview:visualEfView atIndex:0];
    }else {
        [self.tabBar setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithWhite:1.0 alpha:0.96]]];
    }
}

- (void)configureChildViewConstrollers
{
    UIEdgeInsets imageInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    UIOffset titlePosition = UIOffsetMake(0, -2);
    
    [self addChildViewControllerWithClass:[LPPagerViewController class] title:@"资讯" image:@"icon_pgsubject_news_nomal" selectedImage:@"icon_pgsubject_news_focus" imageInsets:imageInsets titlePosition:titlePosition navControllerClass:[LPNavigationController class]];
    
    [self addChildViewControllerWithClass:[ViewController class] title:@"精选" image:@"icon_pgsubject_recommend_nomal" selectedImage:@"icon_pgsubject_recommend_focus"imageInsets:imageInsets titlePosition:titlePosition navControllerClass:[LPNavigationController class]];
    
    [self addChildViewControllerWithClass:[ViewController class] title:@"社区" image:@"icon_pgsubject_bbs_nomal" selectedImage:@"icon_pgsubject_bbs_focus"imageInsets:imageInsets titlePosition:titlePosition navControllerClass:[LPNavigationController class]];
    
    [self addChildViewControllerWithClass:[ViewController class] title:@"我" image:@"icon_pgsubject_my_nomal" selectedImage:@"icon_pgsubject_my_focus"imageInsets:imageInsets titlePosition:titlePosition navControllerClass:[LPNavigationController class]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
