//
//  LPNavigationController.m
//  LovePlayNews
//
//  Created by tany on 16/8/1.
//  Copyright © 2016年 tany. All rights reserved.
//

#import "LPNavigationController.h"

@interface LPNavigationController ()

@end

@implementation LPNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
     [self configureNavBarTheme];
}

- (void)configureNavBarTheme
{
    // 设置导航栏的标题颜色，字体
    NSDictionary* textAttrs = @{NSForegroundColorAttributeName:
                                    [UIColor blackColor],
                                NSFontAttributeName:
                                    [UIFont fontWithName:@"Helvetica"size:18.0],
                                };
    [self.navigationBar setTitleTextAttributes:textAttrs];
    
    //设置导航栏的背景图片
//    [self.navigationBar setBackgroundImage:[UIImage imageNamed:@"img_pgsubject_headerbg"] forBarMetrics:UIBarMetricsDefault];
    
    // 去掉导航栏底部阴影
//    [self.navigationBar setShadowImage:[[UIImage alloc]init]];
    
}

#pragma mark - override

// override pushViewController
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.viewControllers.count >= 1) {
        
        viewController.hidesBottomBarWhenPushed = YES;
    }
    
    [super pushViewController:viewController animated:animated];
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
