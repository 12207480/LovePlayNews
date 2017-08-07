//
//  LPPagerViewController.m
//  LovePlayNews
//
//  Created by tany on 16/8/1.
//  Copyright © 2016年 tany. All rights reserved.
//

#import "LPNewsPagerController.h"
#import "LPNewsListController.h"

@interface LPNewsPagerController ()<TYTabPagerControllerDataSource, TYTabPagerControllerDelegate>

@property (nonatomic, strong) NSArray *newsPageInfos;

@end

@implementation LPNewsPagerController

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

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // 把视图扩展到底部tabbar
    self.edgesForExtendedLayout = UIRectEdgeBottom;
    
    [self loadData];
    
    [self configureTabButtonPager];
    
    [self reloadData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)configurePagerStyles
{
    self.tabBarHeight = 56;
}

- (void)configureTabButtonPager
{
    self.dataSource = self;
    self.delegate = self;
    self.tabBar.layout.barStyle = TYPagerBarStyleProgressElasticView;
    self.tabBar.layout.normalTextFont = [UIFont systemFontOfSize:17];
    self.tabBar.layout.selectedTextFont = [UIFont systemFontOfSize:20];
    self.tabBar.backgroundColor = RGB_255(34, 34, 34);
    self.tabBar.layout.progressColor = RGB_255(237, 67, 89);
    self.tabBar.layout.normalTextColor = [UIColor whiteColor];
    self.tabBar.layout.selectedTextColor = RGB_255(237, 67, 89);
    self.tabBar.layout.cellWidth = 38;
    self.tabBar.layout.sectionInset = UIEdgeInsetsMake(16, 12, 0, 12);
    self.tabBar.layout.cellSpacing = (kScreenWidth - _newsPageInfos.count*self.tabBar.layout.cellWidth - 2*self.tabBar.layout.sectionInset.left)/(_newsPageInfos.count-1);
    self.tabBar.layout.cellEdging = 0;
    self.tabBar.layout.progressVerEdging = 3;
}

#pragma mark - load data

- (void)loadData
{
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"NewsInfo" ofType:@"plist"];
    NSDictionary *data = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
    _newsPageInfos = [data objectForKey:@"newsPageInfos"];
}

#pragma mark - TYPagerControllerDataSource

- (NSInteger)numberOfControllersInTabPagerController
{
    return _newsPageInfos.count;
}

- (NSString *)tabPagerController:(TYTabPagerController *)tabPagerController titleForIndex:(NSInteger)index
{
    NSDictionary *newsPageInfo = _newsPageInfos[index];
    NSString *title = [newsPageInfo objectForKey:@"title"];
    return title ? title : @"";
}

- (UIViewController *)tabPagerController:(TYTabPagerController *)tabPagerController controllerForIndex:(NSInteger)index prefetching:(BOOL)prefetching
{
    NSDictionary *newsPageInfo = _newsPageInfos[index];
    LPNewsListController *newsVC = [[LPNewsListController alloc]init];
    newsVC.newsTopId = [newsPageInfo objectForKey:@"topId"];
    // 扩展到底部tabbar
    newsVC.extendedTabBarInset = YES;
    return newsVC;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
