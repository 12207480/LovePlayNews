//
//  LPZonePagerController.m
//  LovePlayNews
//
//  Created by tanyang on 16/9/4.
//  Copyright © 2016年 tany. All rights reserved.
//

#import "LPZonePagerController.h"
#import "LPHotZoneController.h"
#import "LPZoneDiscuzController.h"

@interface LPZonePagerController ()<TYTabPagerControllerDataSource, TYTabPagerControllerDelegate>

@property (nonatomic, strong) NSArray *datas;

@end

@implementation LPZonePagerController

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
    self.view.backgroundColor = [UIColor whiteColor];
    // 把视图扩展到底部tabbar
    self.edgesForExtendedLayout = UIRectEdgeBottom;
    
    _datas = @[@"热门推荐",@"爱玩社区",@"凯恩之角"];
    
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
    self.tabBar.backgroundColor = RGB_255(34, 34, 34);
    self.tabBar.layout.normalTextFont = [UIFont systemFontOfSize:17];
    self.tabBar.layout.selectedTextFont = [UIFont systemFontOfSize:20];
    self.tabBar.layout.progressColor = RGB_255(237, 67, 89);
    self.tabBar.layout.normalTextColor = [UIColor whiteColor];
    self.tabBar.layout.selectedTextColor = RGB_255(237, 67, 89);
    self.tabBar.layout.cellWidth = 80;
    self.tabBar.layout.cellSpacing = 15;
    CGFloat collectionLayoutEdging = (kScreenWidth-_datas.count*self.tabBar.layout.cellWidth-(_datas.count-1)*self.tabBar.layout.cellSpacing)/2;
    self.tabBar.layout.sectionInset = UIEdgeInsetsMake(16, collectionLayoutEdging, 0, collectionLayoutEdging);
    self.tabBar.layout.progressVerEdging = 3;
    self.tabBar.layout.progressHorEdging = 16;
}

#pragma mark - TYPagerControllerDataSource

- (NSInteger)numberOfControllersInTabPagerController
{
    return _datas.count;
}

- (NSString *)tabPagerController:(TYTabPagerController *)tabPagerController titleForIndex:(NSInteger)index
{
    return _datas[index];
}

- (UIViewController *)tabPagerController:(TYTabPagerController *)tabPagerController controllerForIndex:(NSInteger)index prefetching:(BOOL)prefetching
{
    switch (index) {
        case 0:
        {
            LPHotZoneController *hotZoneVC = [[LPHotZoneController alloc]init];
            hotZoneVC.extendedTabBarInset = YES;
            return hotZoneVC;
        }
        case 1:
        case 2:
        {
            LPZoneDiscuzController *discuzVC = [[LPZoneDiscuzController alloc]init];
            discuzVC.discuzId = index-1;
            discuzVC.extendedTabBarInset = YES;
            return discuzVC;
        }
        default:
        {
            return nil;
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
