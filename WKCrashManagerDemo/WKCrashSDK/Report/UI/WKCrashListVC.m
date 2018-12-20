//
//  WKCrashListVC.m
//  MKWeekly
//
//  Created by wangkun on 2018/7/8.
//  Copyright © 2018年 zymk. All rights reserved.
//

#import "WKCrashListVC.h"
#import "WKCrashListCell.h"
#import "WKCrashReport.h"
#import "WKCrashTypeListVC.h"
@interface WKCrashListVC ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) NSArray * dataSource;

@end

@implementation WKCrashListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"CrashList";
    [self dataSource];
    [self.view addSubview:self.tableView];
    self.tableView.frame = CGRectMake(0, self.nav.bottom, SCREEN_WIDTH, SCREEN_HEIGHT - self.nav.bottom);
    [self.tableView reloadData];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [WKCrashReport setWarnningTextWithType:999];

}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:(UITableViewStylePlain)];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[WKCrashListCell class] forCellReuseIdentifier:@"crashListCell"];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 100;
//        _tableView.rowHeight = UITableViewAutomaticDimension;
    }
    return _tableView;
}

- (NSArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = [WKCrashReport getAllCrashReport];
    }
    return _dataSource;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    WKCrashTypeListVC * vc = [WKCrashTypeListVC new];
    vc.dataSource = self.dataSource[indexPath.row];
    vc.title = [WKCrashReport getPathKeyWithType:indexPath.row];
    [WKCrashReport setWarnningTextWithType:indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WKCrashListCell * cell = [tableView dequeueReusableCellWithIdentifier:@"crashListCell"];
    if (!cell) {
        cell = [[WKCrashListCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"crashListCell"];
    }
    cell.titleLabel.text = [WKCrashReport getPathKeyWithType:indexPath.row];
    NSDictionary * dict = self.dataSource[indexPath.row];
    cell.countLabel.text = [NSString stringWithFormat:@"%ld",dict.count];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
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
