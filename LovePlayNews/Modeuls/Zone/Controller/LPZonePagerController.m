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

@interface LPZonePagerController ()

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
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)configurePagerStyles
{
    self.adjustStatusBarHeight = YES;
    self.contentTopEdging = 44;
    self.barStyle = TYPagerBarStyleProgressElasticView;
}

- (void)configureTabButtonPager
{
    self.pagerBarView.backgroundColor = RGB_255(34, 34, 34);
    self.progressColor = RGB_255(237, 67, 89);
    self.normalTextColor = [UIColor whiteColor];
    self.selectedTextColor = RGB_255(237, 67, 89);
    self.cellWidth = 80;
    self.cellSpacing = 15;
    self.collectionLayoutEdging = (kScreenWidth-_datas.count*self.cellWidth-(_datas.count-1)*self.cellSpacing)/2;
    self.progressBottomEdging = 3;
    self.progressEdging = 16;
}

#pragma mark - TYPagerControllerDataSource

- (NSInteger)numberOfControllersInPagerController
{
    return _datas.count;
}

- (NSString *)pagerController:(TYPagerController *)pagerController titleForIndex:(NSInteger)index
{
    return _datas[index];
}

- (UIViewController *)pagerController:(TYPagerController *)pagerController controllerForIndex:(NSInteger)index
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
