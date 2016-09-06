//
//  LPTabBarController.m
//  LovePlayNews
//
//  Created by tany on 16/8/1.
//  Copyright © 2016年 tany. All rights reserved.
//

#import "LPTabBarController.h"
#import "UITabBarController+AddChildVC.h"
#import "UIImage+Color.h"
#import "LPNavigationController.h"
#import "LPNewsPagerController.h"
#import "LPRecommendController.h"
#import "LPZonePagerController.h"
#import "LPMineViewController.h"

@interface LPTabBarController ()

@end

@implementation LPTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self configureTabBar];
    
    [self configureChildViewControllers];
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
        [self.tabBar setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRed:238/255.0 green:240/255.0 blue:245/255.0 alpha:0.78]]];
        // blur效果
        UIVisualEffectView *visualEfView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
        visualEfView.frame = CGRectMake(0, -1, CGRectGetWidth(self.tabBar.frame), CGRectGetHeight(self.tabBar.frame)+1);
        visualEfView.alpha = 1.0;
        [self.tabBar insertSubview:visualEfView atIndex:0];
    }
    
    [[UITabBarItem appearanceWhenContainedIn:[LPTabBarController class], nil] setTitleTextAttributes:@{NSForegroundColorAttributeName :[UIColor colorWithRed:113/255.0 green:113/255.0 blue:113/255.0 alpha:1.0] } forState:UIControlStateNormal];
    
    [[UITabBarItem appearanceWhenContainedIn:[LPTabBarController class], nil] setTitleTextAttributes:@{NSForegroundColorAttributeName :[UIColor colorWithRed:218/255.0 green:85/255.0 blue:107/255.0 alpha:1.0] } forState:UIControlStateSelected];
}

- (void)configureChildViewControllers
{
    // 资讯
    [self addNewsController];
    
    // 精选
    [self addRecommendController];
    
    // 社区
    [self addZoneController];
    
    // 我的
    [self addMineController];
}

#pragma mark - add childVC

- (void)addNewsController
{
    UIEdgeInsets imageInsets = UIEdgeInsetsZero;
    UIOffset titlePosition = UIOffsetMake(0, -2);
    
    LPNewsPagerController *newsPagerController = [[LPNewsPagerController alloc]init];
    
    [self addChildViewController:newsPagerController title:@"资讯" image:@"icon_zx_nomal_pgall" selectedImage:@"icon_zx_pressed_pgall" imageInsets:imageInsets titlePosition:titlePosition navControllerClass:[LPNavigationController class]];
}

- (void)addRecommendController
{
    UIEdgeInsets imageInsets = UIEdgeInsetsZero;
    UIOffset titlePosition = UIOffsetMake(0, -2);

    LPRecommendController *recommendController = [[LPRecommendController alloc]init];
    [self addChildViewController:recommendController title:@"精选" image:@"icon_jx_nomal_pgall" selectedImage:@"icon_jx_pressed_pgall"imageInsets:imageInsets titlePosition:titlePosition navControllerClass:[LPNavigationController class]];
}

- (void)addZoneController
{
    UIEdgeInsets imageInsets = UIEdgeInsetsZero;
    UIOffset titlePosition = UIOffsetMake(0, -2);
    
    LPZonePagerController *zoneController = [[LPZonePagerController alloc]init];
    [self addChildViewController:zoneController title:@"社区" image:@"icon_sq_nomal_pgall" selectedImage:@"icon_sq_pressed_pgall"imageInsets:imageInsets titlePosition:titlePosition navControllerClass:[LPNavigationController class]];
}

- (void)addMineController
{
    UIEdgeInsets imageInsets = UIEdgeInsetsZero;
    UIOffset titlePosition = UIOffsetMake(0, -2);
    
    LPMineViewController *mineController = [[LPMineViewController alloc]init];
    [self addChildViewController:mineController title:@"我" image:@"icon_w_nomal_pgall" selectedImage:@"icon_w_pressed_pgall"imageInsets:imageInsets titlePosition:titlePosition navControllerClass:[LPNavigationController class]];
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
