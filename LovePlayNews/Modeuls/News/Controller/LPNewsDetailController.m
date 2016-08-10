//
//  LPNewsDetailController.m
//  LovePlayNews
//
//  Created by tanyang on 16/8/6.
//  Copyright © 2016年 tany. All rights reserved.
//

#import "LPNewsDetailController.h"
#import "LPWebCellNode.h"
#import "LPNewsRequestOperation.h"

@interface LPNewsDetailController ()<ASTableDelegate, ASTableDataSource>

// UI
@property (nonatomic, strong) ASTableNode *tableNode;

@end

@implementation LPNewsDetailController

- (instancetype)init
{
    _tableNode = [[ASTableNode alloc] init];
    if (self = [super initWithNode:_tableNode]) {
        _tableNode.delegate = self;
        _tableNode.dataSource = self;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    _tableNode.view.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableNode.view.tableFooterView = [[UIView alloc]init];
    
    [self loadData];
}

- (void)loadData
{
    LPHttpRequest *newsListRequest = [LPNewsRequestOperation requestNewsDetailWithNewsId:_newsId];
    
    [newsListRequest loadWithSuccessBlock:^(LPHttpRequest *request) {
        
    } failureBlock:^(LPHttpRequest *request, NSError *error) {
        
    }];
    
}

#pragma mark - ASTableDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (ASCellNodeBlock)tableView:(ASTableView *)tableView nodeBlockForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //http://m.wx.233.com/news/home/newsdetail?newsId=53772&fsClassId=339
    ASCellNode *(^cellNodeBlock)() = ^ASCellNode *() {
        LPWebCellNode *cellNode = [[LPWebCellNode alloc] initWithURL:[NSURL URLWithString:@"http://play.163.com/16/0808/00/BTTGG4TT00314V8J.html"]];
        return cellNode;
    };
    return cellNodeBlock;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
    _tableNode.delegate = nil;
    _tableNode.dataSource = nil;
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
