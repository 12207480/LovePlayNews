//
//  LPGameNewsController.m
//  LovePlayNews
//
//  Created by tany on 16/8/29.
//  Copyright © 2016年 tany. All rights reserved.
//

#import "LPGameNewsController.h"
#import "LPNewsListController.h"

@interface LPGameNewsController ()

// UI
@property (nonatomic, weak) LPNewsListController *newsListVC;

@end

@implementation LPGameNewsController

#pragma mark - life cycle

- (instancetype)init
{
    if (self = [super initWithNode:[ASDisplayNode new]]) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view layoutIfNeeded];
    
    [self addNewsListController];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    _newsListVC.view.frame = self.node.bounds;
}

- (void)addNewsListController
{
    LPNewsListController *newsListVC = [[LPNewsListController alloc]init];
    newsListVC.newsTopId = _newsTopId;
    newsListVC.sourceType = _sourceType;
    [self addChildViewController:newsListVC];
    [self.view addSubview:newsListVC.view];
    _newsListVC = newsListVC;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
