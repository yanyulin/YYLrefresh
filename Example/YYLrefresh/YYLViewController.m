//
//  YYLViewController.m
//  YYLrefresh
//
//  Created by yanyulin on 07/06/2017.
//  Copyright (c) 2017 yanyulin. All rights reserved.
//

#import "YYLViewController.h"
#import "UITableView+Refresh.h"
#import <MJRefresh/MJRefresh.h>

@interface YYLViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UISegmentedControl *segmentedControl;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataArrayM;

@end

@implementation YYLViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.titleView = self.segmentedControl;
    [self.view addSubview:self.tableView];
    
    [self.tableView.mj_header beginRefreshing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - event
- (void)segmentedControlValueChange:(UISegmentedControl *)segmentedControl {
    NSInteger index = segmentedControl.selectedSegmentIndex;
    switch (index) {
        case 0:
            self.tableView.loadErrorType = RCLoadErrorTypeDefalt;
            break;
        case 1:
            self.tableView.loadErrorType = RCLoadErrorTypeRequest;
            break;
        case 2:
            self.tableView.loadErrorType = RCLoadErrorTypeNoNetwork;
            break;
        case 3:
            self.tableView.loadErrorType = RCLoadErrorTypeNoData;
            break;
        default:
            break;
    }
}

//模拟网络请求
- (void)loadData {
    
    __weak typeof(self) weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakSelf.dataArrayM addObjectsFromArray:@[@"测试", @"测试", @"测试", @"测试", @"测试"]];
        [weakSelf.tableView endRefreshing];
    });
}

#pragma mark- UITableViewDelegate, UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArrayM.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellId = @"cellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %zd", self.dataArrayM[indexPath.row], indexPath.row];
    return cell;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.isShowHeaderRefresh = YES;
        _tableView.isShowFooterRefresh = YES;
        __weak typeof(self) weakSelf = self;
        _tableView.headerRefreshingBlock = ^{
            [weakSelf.dataArrayM removeAllObjects];
            [weakSelf loadData];
        };
        _tableView.footerRefreshingBlock = ^{
            
            [weakSelf loadData];
        };
    }
    return _tableView;
}

- (UISegmentedControl *)segmentedControl {
    if (!_segmentedControl) {
        _segmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"有数据",@"请求出错", @"无网络", @"无数据"]];
        _segmentedControl.selectedSegmentIndex = 0;
        [_segmentedControl addTarget:self action:@selector(segmentedControlValueChange:) forControlEvents:UIControlEventValueChanged];
    }
    return _segmentedControl;
}

- (NSMutableArray *)dataArrayM {
    if (!_dataArrayM) {
        _dataArrayM = [NSMutableArray array];
    }
    return _dataArrayM;
}
@end
