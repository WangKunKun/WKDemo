//
//  WKCarshTypeListVC.m
//  MKWeekly
//
//  Created by wangkun on 2018/7/8.
//  Copyright © 2018年 zymk. All rights reserved.
//

#import "WKCrashTypeListVC.h"
#import "WKCrashListCell.h"
#import "WKCrashReport.h"
#import "WKCrashClassListVC.h"
@interface WKCrashTypeListVC ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView * tableView;

@end

@implementation WKCrashTypeListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self dataSource];
    [self.view addSubview:self.tableView];
    self.tableView.frame = CGRectMake(0, self.nav.bottom, SCREEN_WIDTH, SCREEN_HEIGHT - self.nav.bottom);

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
    }
    return _tableView;
}

-(void)setDataSource:(NSDictionary *)dataSource
{
    _dataSource = dataSource;
    [self.tableView reloadData];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    WKCrashClassListVC * vc = [WKCrashClassListVC new];
    NSString * key = self.dataSource.allKeys[indexPath.row];

    vc.dataSource = [self.dataSource objectForKey:key];
    vc.title = key;
    [self.navigationController pushViewController:vc animated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WKCrashListCell * cell = [tableView dequeueReusableCellWithIdentifier:@"crashListCell"];
    if (!cell) {
        cell = [[WKCrashListCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"crashListCell"];
    }
    NSString * key = self.dataSource.allKeys[indexPath.row];
    cell.titleLabel.text = key;
    cell.countLabel.text = [NSString stringWithFormat:@"%ld",[(NSArray *)[self.dataSource objectForKey:key] count]];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

@end
