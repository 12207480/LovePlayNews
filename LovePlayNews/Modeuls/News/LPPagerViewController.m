//
//  LPPagerViewController.m
//  LovePlayNews
//
//  Created by tany on 16/8/1.
//  Copyright © 2016年 tany. All rights reserved.
//

#import "LPPagerViewController.h"

@interface LPPagerViewController ()
@end

@implementation LPPagerViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        self.contentTopEdging = 44;
        self.collectionLayoutEdging = 8;
        self.barStyle = TYPagerBarStyleProgressBounceView;
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        self.contentTopEdging = 44;
        self.collectionLayoutEdging = 8;
        self.barStyle = TYPagerBarStyleProgressBounceView;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.pagerBarImageView.image = [UIImage imageNamed:@"img_pgsubject_headerbg"];
    self.normalTextColor = [UIColor whiteColor];
    //self.selectedTextColor =
    self.adjustStatusBarHeight = YES;
    self.cellSpacing = 8;
    self.progressBottomEdging = 3;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

#pragma mark - TYPagerControllerDataSource

- (NSInteger)numberOfControllersInPagerController
{
    return 30;
}

- (NSString *)pagerController:(TYPagerController *)pagerController titleForIndex:(NSInteger)index
{
    return index %2 == 0 ? [NSString stringWithFormat:@"Tab %ld",index]:[NSString stringWithFormat:@"Tab Tab %ld",index];
}

- (UIViewController *)pagerController:(TYPagerController *)pagerController controllerForIndex:(NSInteger)index
{
    UIViewController *VC = [[UIViewController alloc]init];
    VC.view.backgroundColor = [UIColor colorWithRed:arc4random()%255/255.0 green:arc4random()%255/255.0 blue:arc4random()%255/255.0 alpha:arc4random()%255/255.0];
    return VC;
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
