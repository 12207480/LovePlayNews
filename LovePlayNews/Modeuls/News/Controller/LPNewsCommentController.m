//
//  LPNewsCommentController.m
//  LovePlayNews
//
//  Created by tanyang on 16/8/20.
//  Copyright © 2016年 tany. All rights reserved.
//

#import "LPNewsCommentController.h"
#import "LPNavigationBarView.h"
#import "UIView+Nib.h"

@interface LPNewsCommentController ()

// UI
@property (nonatomic, strong) ASTableNode *tableNode;
@property (nonatomic, weak) LPNavigationBarView *navBar;

@end

@implementation LPNewsCommentController

- (instancetype)init
{
    if (self = [super initWithNode:[ASDisplayNode new]]) {
        
        [self addTableNode];
    }
    return self;
}

- (void)addTableNode
{
    _tableNode = [[ASTableNode alloc] initWithStyle:UITableViewStyleGrouped];
    _tableNode.backgroundColor = RGB_255(247, 247, 247);
//    _tableNode.delegate = self;
//    _tableNode.dataSource = self;
    [self.node addSubnode:_tableNode];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self configureController];
    
    [self addNavBarView];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    _navBar.frame = CGRectMake(0, 0, CGRectGetWidth(self.node.frame), kNavBarHeight);
    _tableNode.frame = CGRectMake(0, kNavBarHeight, CGRectGetWidth(self.node.frame), CGRectGetHeight(self.node.frame) - kNavBarHeight);
}

- (void)configureController
{
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)addNavBarView
{
    LPNavigationBarView *navBar = [LPNavigationBarView loadInstanceFromNib];
    [self.node.view addSubview:navBar];
    _navBar = navBar;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
