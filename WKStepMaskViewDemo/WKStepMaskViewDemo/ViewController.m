//
//  ViewController.m
//  WKStepMaskViewDemo
//
//  Created by wangkun on 2018/3/26.
//  Copyright © 2018年 wangkun. All rights reserved.
//

#import "ViewController.h"
#import "StepMaskGuideView.h"
@interface ViewController ()

@property (nonatomic, strong) StepMaskGuideView * guideView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    NSMutableArray * models = [NSMutableArray array];
    {
        UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH / 2.0 - 30 / 2.0, 120, 50, 30)];
        label.textColor = [UIColor greenColor];
        label.font = [UIFont systemFontOfSize:15];
        label.text = @"头像";
        label.textAlignment = NSTextAlignmentCenter;
        label.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:label];
        WKStepMaskModel * model = [WKStepMaskModel creatModelWithView:label cornerRadius:0 step:0];
        [models addObject:model];
    }
    
    {
        UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH / 2.0 - 30 / 2.0, 200, 50, 30)];
        label.textColor = [UIColor redColor];
        label.font = [UIFont systemFontOfSize:15];
        label.text = @"任务";
        label.textAlignment = NSTextAlignmentCenter;
        label.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:label];
        WKStepMaskModel * model = [WKStepMaskModel creatModelWithFrame:label.frame cornerRadius:0 step:1];
        [models addObject:model];
    }
    
    {
        UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH / 2.0 - 30 / 2.0, 280, 50, 30)];
        label.textColor = [UIColor redColor];
        label.font = [UIFont systemFontOfSize:15];
        label.text = @"设置";
        label.textAlignment = NSTextAlignmentCenter;
        label.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:label];
        WKStepMaskModel * model = [WKStepMaskModel creatModelWithView:label cornerRadius:0 step:2];
        [models addObject:model];
    }
    
    {
        UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH / 2.0 - 30 / 2.0, 380, 50, 30)];
        label.textColor = [UIColor redColor];
        label.font = [UIFont systemFontOfSize:15];
        label.text = @"欢迎";
        label.textAlignment = NSTextAlignmentCenter;
        label.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:label];
        WKStepMaskModel * model = [WKStepMaskModel creatModelWithView:label cornerRadius:0 step:2];
        [models addObject:model];
    }
    

    _guideView = [[StepMaskGuideView alloc] initWithModels:models];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [_guideView showInView:self.view isShow:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
