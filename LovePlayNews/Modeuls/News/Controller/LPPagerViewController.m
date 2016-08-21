//
//  LPPagerViewController.m
//  LovePlayNews
//
//  Created by tany on 16/8/1.
//  Copyright © 2016年 tany. All rights reserved.
//

#import "LPPagerViewController.h"
#import "LPNewsListController.h"

@interface LPPagerViewController ()
@property (nonatomic, strong) NSArray *newsPageInfos;
@end

@implementation LPPagerViewController

#pragma mark - lifeCycle

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        
        [self configurePagerStyles];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        
        [self configurePagerStyles];
    }
    return self;
}

- (void)configurePagerStyles
{
    self.adjustStatusBarHeight = YES;
    self.contentTopEdging = 44;
    self.collectionLayoutEdging = 12;
    self.barStyle = TYPagerBarStyleProgressBounceView;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.pagerBarView.backgroundColor = RGB_255(34, 34, 34);
    self.progressColor = RGB_255(237, 67, 89);
    self.normalTextColor = [UIColor whiteColor];
    self.selectedTextColor = RGB_255(237, 67, 89);
    self.cellSpacing = 20;
    self.progressBottomEdging = 3;
    
    [self loadData];
}

- (void)loadData
{
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"NewsInfo" ofType:@"plist"];
    NSDictionary *data = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
    _newsPageInfos = [data objectForKey:@"newsPageInfos"];
}

#pragma mark - TYPagerControllerDataSource

- (NSInteger)numberOfControllersInPagerController
{
    return _newsPageInfos.count;
}

- (NSString *)pagerController:(TYPagerController *)pagerController titleForIndex:(NSInteger)index
{
    NSDictionary *newsPageInfo = _newsPageInfos[index];
    NSString *title = [newsPageInfo objectForKey:@"title"];
    return title ? title : @"";
}

- (UIViewController *)pagerController:(TYPagerController *)pagerController controllerForIndex:(NSInteger)index
{
    NSDictionary *newsPageInfo = _newsPageInfos[index];
    LPNewsListController *newsVC = [[LPNewsListController alloc]init];
    newsVC.newsTitle = [newsPageInfo objectForKey:@"title"];
    newsVC.newsTopId = [newsPageInfo objectForKey:@"topId"];
    return newsVC;
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
