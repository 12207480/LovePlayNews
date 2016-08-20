//
//  LPNewsListViewController.m
//  LovePlayNews
//
//  Created by tany on 16/8/3.
//  Copyright © 2016年 tany. All rights reserved.
//

#import "LPNewsListController.h"
#import "LPNewsRequestOperation.h"
#import "MBProgressHUD+MJ.h"
#import "LPNewsCellNode.h"
#import "LPNewsImageCellNode.h"
#import "LPNewsDetailController.h"

@interface LPNewsListController ()<ASTableDelegate, ASTableDataSource>

// UI
@property (nonatomic, strong) ASTableNode *tableNode;

// Data
@property (nonatomic, strong) NSArray *newsList;

@property (nonatomic, assign) NSInteger curIndexPage;

@end

@implementation LPNewsListController

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
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    _tableNode.view.tableFooterView = [[UIView alloc]init];
    _tableNode.view.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self loadData];
}

- (void)loadData
{
    _curIndexPage = 0;
    [MBProgressHUD showMessage:@"加载中..." toView:self.view];
    LPHttpRequest *newsListRequest = [LPNewsRequestOperation requestNewsListWithTopId:_newsTopId pageIndex:_curIndexPage];
    [newsListRequest loadWithSuccessBlock:^(LPHttpRequest *request) {
        _newsList = request.responseObject.data;
        [_tableNode.view reloadData];
        _curIndexPage++;
        [MBProgressHUD hideHUDForView:self.view];
    } failureBlock:^(id<TYRequestProtocol> request, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view];
    }];
}

- (void)loadMoreDataWithContext:(ASBatchContext *)context
{
    if (context) {
        [context beginBatchFetching];
    }
    
    LPHttpRequest *newsListRequest = [LPNewsRequestOperation requestNewsListWithTopId:_newsTopId pageIndex:_curIndexPage];
    [newsListRequest loadWithSuccessBlock:^(LPHttpRequest *request) {
        NSArray *newsList = request.responseObject.data;
        if (newsList.count > 0) {
             NSMutableArray *indexPaths = [NSMutableArray array];
            for (NSInteger row = _newsList.count; row<_newsList.count+newsList.count; ++row) {
                [indexPaths addObject:[NSIndexPath indexPathForRow:row inSection:0]];
            }
           _newsList = [_newsList arrayByAddingObjectsFromArray:newsList];
            [_tableNode.view insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
            _curIndexPage++;
        }
        if (context) {
            [context completeBatchFetching:YES];
        }
    } failureBlock:^(id<TYRequestProtocol> request, NSError *error) {
        if (context) {
            [context completeBatchFetching:YES];
        }
    }];
}

#pragma mark - ASTableDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _newsList.count;
}

- (ASCellNodeBlock)tableView:(ASTableView *)tableView nodeBlockForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LPNewsInfoModel *newsInfo = _newsList[indexPath.row];
    ASCellNode *(^cellNodeBlock)() = ^ASCellNode *() {
        LPNewsBaseCellNode *cellNode = nil;
        switch (newsInfo.showType) {
            case 2:
                cellNode = [[LPNewsImageCellNode alloc] initWithNewsInfo:newsInfo];
                break;
            default:
                cellNode = [[LPNewsCellNode alloc] initWithNewsInfo:newsInfo];
                break;
        }
        return cellNode;
    };
    return cellNodeBlock;
}

- (BOOL)shouldBatchFetchForTableView:(ASTableView *)tableView
{
    return _newsList.count;
}

- (void)tableView:(ASTableView *)tableView willBeginBatchFetchWithContext:(ASBatchContext *)context
{
    [self loadMoreDataWithContext:context];
}

#pragma mark - ASTableDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    LPNewsInfoModel *newsInfo = _newsList[indexPath.row];
    LPNewsDetailController *detail = [[LPNewsDetailController alloc]init];
    detail.newsId = newsInfo.docid;
    [self.navigationController pushViewController:detail animated:YES];
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
