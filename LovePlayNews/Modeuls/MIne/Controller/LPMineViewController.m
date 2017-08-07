//
//  LPMineViewController.m
//  LovePlayNews
//
//  Created by tanyang on 16/9/5.
//  Copyright © 2016年 tany. All rights reserved.
//

#import "LPMineViewController.h"
#import "LPTableItemCell.h"
#import "LPPrizeViewCell.h"
#import "LPTableViewItem.h"
#import "LPMineHeaderView.h"
#import "MXParallaxHeader.h"

@interface LPMineViewController ()<UITableViewDataSource, UITableViewDelegate>

// UI
@property (nonatomic, weak) UITableView *tableView;

// Data
@property (nonatomic, strong) NSArray *sections;

@end

static NSString *tableItemCellId = @"LPTableItemCell";
static NSString *tablePrizeCellId = @"LPPrizeViewCell";

@implementation LPMineViewController

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self addTableView];
    
    [self addTableHeaderView];
    
    [self registerdTableViewCells];
    
    [self addTableViewItems];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    _tableView.frame = self.view.bounds;
}

- (void)addTableView
{
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.tableFooterView = [[UIView alloc] init];
    tableView.separatorColor = RGB_255(223, 223, 223);
    tableView.separatorInset = UIEdgeInsetsZero;
    tableView.backgroundView = nil;
    tableView.backgroundColor = RGB_255(246, 246, 246);
    [self.view addSubview:tableView];
    _tableView = tableView;
}

- (void)addTableHeaderView
{
    LPMineHeaderView *headerView = [LPMineHeaderView loadInstanceFromNib];
    _tableView.parallaxHeader.view = headerView;
    _tableView.parallaxHeader.height = 135;
    _tableView.parallaxHeader.mode = MXParallaxHeaderModeFill;
    _tableView.parallaxHeader.contentView.layer.zPosition = 1;
}

- (void)registerdTableViewCells
{
    UINib *nib = [UINib nibWithNibName:tableItemCellId bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:tableItemCellId];
    
    nib = [UINib nibWithNibName:tablePrizeCellId bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:tablePrizeCellId];
}

- (void)addTableViewItems
{
    NSArray *section0 = ({
        LPTableViewItem *item0 = [[LPTableViewItem alloc]initWithTitle:@"积分福利" icon:@"mine_welfare_img"];
        LPTableViewItem *item1 = [[LPTableViewItem alloc]initWithTitle:@"游戏礼包" icon:@"mine_gift_img"];
        @[item0,item1];
    });
    
    NSArray *section1 = ({
        LPTableViewItem *item0 = [[LPTableViewItem alloc]initWithTitle:@"消息"];
        LPTableViewItem *item1 = [[LPTableViewItem alloc]initWithTitle:@"任务"];
        LPTableViewItem *item2 = [[LPTableViewItem alloc]initWithTitle:@"收藏"];
        LPTableViewItem *item3 = [[LPTableViewItem alloc]initWithTitle:@"关注"];
        @[item0,item1,item2,item3];
    });
    
    NSArray *section2 = ({
        LPTableViewItem *item0 = [[LPTableViewItem alloc]initWithTitle:@"设置"];
        LPTableViewItem *item1 = [[LPTableViewItem alloc]initWithTitle:@"意见反馈"];
        @[item0,item1];
    });
    _sections = @[section0,section1,section2];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *sectionItems = _sections[section];
    switch (section) {
        case 0:
            return (sectionItems.count+1)/2;
        case 1:
        case 2:
            return sectionItems.count;
        default:
            return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *sectionItems = _sections[indexPath.section];
    switch (indexPath.section) {
        case 0:
        {
            NSInteger i = indexPath.row/2;
            LPTableViewItem *leftitem  = sectionItems[i*2];
            LPTableViewItem *rightitem  = i*2+1 >= sectionItems.count ? nil : sectionItems[i*2+1];
            LPPrizeViewCell *cell = [tableView dequeueReusableCellWithIdentifier:tablePrizeCellId forIndexPath:indexPath];
            cell.leftItem = leftitem;
            cell.rightItem = rightitem;
            return cell;
        }
        case 1:
        case 2:
        {
            LPTableViewItem *item  = sectionItems[indexPath.row];
            LPTableItemCell *cell = [tableView dequeueReusableCellWithIdentifier:tableItemCellId forIndexPath:indexPath];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.item = item;
            return cell;
        }
        default:
            return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
            return 70;
            
        default:
            return 51;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *sectionItems = _sections[indexPath.section];
     LPTableViewItem *item  = sectionItems[indexPath.row];
    
    BOOL shouldSelect = YES;
    if (item.shouldSelectedHandler) {
        shouldSelect = item.shouldSelectedHandler();
    }
    
    if (!shouldSelect) {
        return;
    }
    
    if (item.selectedHandler) {
        item.selectedHandler();
    }else if (item.destVcClass) {
        UIViewController *VC = [[item.destVcClass alloc]init];
        [self.navigationController pushViewController:VC animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0;
    }
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
