//
//  WKVCDeallocListVC.m
//  MKWeekly
//
//  Created by wangkun on 2018/3/21.
//  Copyright © 2018年 zymk. All rights reserved.
//

#import "WKVCDeallocListVC.h"
#import "WKVCDeallocManger.h"
#import "WKVCDeallocCell.h"
#import "WKPopImageView.h"
@interface WKVCDeallocListVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *mainTableView;
@property (nonatomic,strong) NSMutableArray<WKDeallocModel *> *datasource;
@property (nonatomic,strong) WKPopImageView * popView;
@property (nonatomic,strong) UIButton * bottomBtn;
@property (nonatomic,strong) UIButton * leftBtn;
@property (nonatomic,strong) UIButton * rightBtn;
@property (nonatomic,strong) UILabel * titleLabel;
@property (nonatomic,strong) UIView * line;

@end

@implementation WKVCDeallocListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    self.title = @"未释放的VC";
    self.view.backgroundColor = [UIColor whiteColor];
    self.datasource = [WKVCDeallocManger sharedVCDeallocManager].warnningModels;
    [self.view addSubview:self.titleLabel];
    [self.view addSubview:self.leftBtn];
    [self.view addSubview:self.rightBtn];
    [self.view addSubview:self.line];
    [self.view addSubview:self.bottomBtn];
    [self.view addSubview:self.mainTableView];
    [self.mainTableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)detailItemClick
{

}

- (UITableView *)mainTableView{
    if(!_mainTableView){
        _mainTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, NAVIGATION_STATUS_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - NAVIGATION_STATUS_HEIGHT - 40) style:UITableViewStylePlain];
        _mainTableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        _mainTableView.rowHeight = UITableViewAutomaticDimension;
        _mainTableView.estimatedRowHeight = 110;
        _mainTableView.showsVerticalScrollIndicator = NO;
        _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_mainTableView registerNib:[UINib nibWithNibName:@"WKVCDeallocCell" bundle:nil] forCellReuseIdentifier:@"WKVCDeallocCell"];
    }
    return _mainTableView;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.datasource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WKVCDeallocCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WKVCDeallocCell"];
    cell.model = self.datasource[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    WKDeallocModel * model = (WKDeallocModel *)[self.datasource objectAtIndex:indexPath.row];
    self.popView.img = model.img;
    [self.popView showInView:self.view isShow:YES];


}

- (NSMutableArray<WKDeallocModel *> *)datasource
{
    if (!_datasource) {
        _datasource = [NSMutableArray array];
    }
    return _datasource;
}

- (WKPopImageView *)popView
{
    if (!_popView) {
        _popView = [WKPopImageView new];
    }
    return _popView;
}

- (UIButton *)bottomBtn
{
    if (!_bottomBtn) {
        _bottomBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_bottomBtn setTitle:@"查看所有VC" forState:(UIControlStateNormal)];
        [_bottomBtn setTitle:@"查看未释放的VC" forState:(UIControlStateSelected)];
        [_bottomBtn setBackgroundColor:[UIColor colorWithRed:252 / 255.0 green:100 / 255.0 blue:84 / 255.0 alpha:1]];
        [_bottomBtn addTarget:self action:@selector(changeModel:) forControlEvents:(UIControlEventTouchUpInside)];
        _bottomBtn.frame = CGRectMake(0, SCREEN_HEIGHT - 40, SCREEN_WIDTH, 40);
    }
    return _bottomBtn;
}

- (UIButton *)rightBtn
{
    if (!_rightBtn) {
        
        BOOL isWarnning = [WKVCDeallocManger sharedVCDeallocManager].isWarnning;
        
        _rightBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_rightBtn setTitle: isWarnning ? @"关闭警告" : @"开启警告" forState:(UIControlStateNormal)];
        _rightBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_rightBtn setTitleColor:[UIColor colorWithRed:252 / 255.0 green:100 / 255.0 blue:84 / 255.0 alpha:1] forState:UIControlStateNormal];
        [_rightBtn setTitleColor:[UIColor colorWithRed:252 / 255.0 green:100 / 255.0 blue:84 / 255.0 alpha:1] forState:UIControlStateSelected];
        [_rightBtn addTarget:self action:@selector(changeWaringModel:) forControlEvents:(UIControlEventTouchUpInside)];
        _rightBtn.frame = CGRectMake(SCREEN_WIDTH - 100, 20, 100, 44);

    }
    return _rightBtn;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.frame = CGRectMake(CGRectGetMidX(self.view.frame) - 50, 20, 100, 44);
        _titleLabel.font = [UIFont systemFontOfSize:18];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

- (UIButton *)leftBtn
{
    if (!_leftBtn) {
        _leftBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_leftBtn setTitle:@"退出" forState:(UIControlStateNormal)];
        _leftBtn.titleLabel.font = [UIFont systemFontOfSize:15];

        [_leftBtn setTitleColor:[UIColor colorWithRed:252 / 255.0 green:100 / 255.0 blue:84 / 255.0 alpha:1] forState:UIControlStateNormal];
        [_leftBtn setTitleColor:[UIColor colorWithRed:252 / 255.0 green:100 / 255.0 blue:84 / 255.0 alpha:1] forState:UIControlStateSelected];
        [_leftBtn addTarget:self action:@selector(back) forControlEvents:(UIControlEventTouchUpInside)];
        _leftBtn.frame = CGRectMake(0, 20, 60, 44);

    }
    return _leftBtn;
}

- (void)setTitle:(NSString *)title
{
    [super setTitle:title];
    self.titleLabel.text = title;
}

- (void)changeModel:(UIButton *)sender
{
    sender.selected = !sender.isSelected;
    self.title = [[sender currentTitle] stringByReplacingOccurrencesOfString:@"查看" withString:@""];
    self.datasource = sender.selected ? [WKVCDeallocManger sharedVCDeallocManager].models : [WKVCDeallocManger sharedVCDeallocManager].warnningModels;
    [self.datasource sortUsingComparator:^NSComparisonResult(WKDeallocModel  *_Nonnull obj1, WKDeallocModel * _Nonnull obj2) {
        return obj1.isNeedRelease < obj2.isNeedRelease;
    }];
    [self.mainTableView reloadData];
}

- (void)back
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)changeWaringModel:(UIButton *)btn
{
    BOOL isWarnning = ![WKVCDeallocManger sharedVCDeallocManager].isWarnning;
    [WKVCDeallocManger sharedVCDeallocManager].isWarnning = isWarnning;
    [self.rightBtn setTitle: isWarnning ? @"关闭警告" : @"开启警告" forState:(UIControlStateNormal)];
}

- (UIView *)line
{
    if (!_line) {
        _line = [[UIView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 0.5)];
        _line.backgroundColor = [UIColor blackColor];
    }
    return _line;
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
