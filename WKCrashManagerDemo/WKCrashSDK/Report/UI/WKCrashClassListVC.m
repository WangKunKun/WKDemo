//
//  WKCrashClassListVC.m
//  MKWeekly
//
//  Created by wangkun on 2018/7/8.
//  Copyright © 2018年 zymk. All rights reserved.
//

#import "WKCrashClassListVC.h"
#import "WKCrashClassCell.h"
#import "WKCrashReport.h"
@interface WKCrashClassListVC ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView * tableView;

@end

@implementation WKCrashClassListVC


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
    
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:(UITableViewStylePlain)];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[WKCrashClassCell class] forCellReuseIdentifier:@"WKCrashClassCell"];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 100;
    }
    return _tableView;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WKCrashClassCell * cell = [tableView dequeueReusableCellWithIdentifier:@"WKCrashClassCell"];
    if (!cell) {
        cell = [[WKCrashClassCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"WKCrashClassCell"];
    }
    NSString * str = self.dataSource[indexPath.row];
    NSArray * arr = [WKCrashReport decodeWithString:str];
    cell.titleLabel.text = arr.firstObject;
    cell.countLabel.text = arr[1];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate * date = [NSDate dateWithTimeIntervalSince1970:[arr.lastObject doubleValue]];
    cell.timeLabel.text = [dateFormatter stringFromDate:date];;
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

@end
