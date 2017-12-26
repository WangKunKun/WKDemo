//
//  ViewController.m
//  searchKeyChangeColor
//
//  Created by wangkun on 2017/12/26.
//  Copyright © 2017年 wangkun. All rights reserved.
//

#import "ViewController.h"
#import "NSString+WKExtend.h"
#import "WKSearchStringManager.h"
static NSString * str = @"爱上对方过后就哭了去玩儿推哦平QWERTYuiop破子线程膜拜VB膜拜129037129371ask的就好思考阿萨德看见阿里是点击你们能这东西不参加按时打卡hi哦呜二批全文浩丰科技sad女奥斯卡来交换asdkjsasdklfaklsdfhasklhfwiuqwipoehfqkehfkasdqowpeiqwoieupwoiadnaf,msdnm,cvzxncbjvsodyipeu-12-92-30481203=81203-/./,/'l;02-09";

@interface ViewController ()<UITextFieldDelegate>

@property (nonatomic, strong) UILabel * textLabel;
@property (nonatomic, strong) UITextField * textField;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self.view addSubview:self.textLabel];
    [self.view addSubview:self.textField];
    
    self.textLabel.text = str;
    
    
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.textField.text = @"a";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UILabel *)textLabel
{
    if (!_textLabel) {
        _textLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 120,  [UIScreen mainScreen].bounds.size.width - 40, 299)];
        _textLabel.numberOfLines = 0;
        _textLabel.font = [UIFont systemFontOfSize:15];
        _textLabel.layer.cornerRadius = 5;
        _textLabel.layer.borderColor = [UIColor lightTextColor].CGColor;
        _textLabel.layer.borderWidth = 0.5;
        
    }
    return _textLabel;
}

- (UITextField *)textField
{
    if (!_textField) {
        _textField = [[UITextField  alloc] initWithFrame:CGRectMake(20, 60, [UIScreen mainScreen].bounds.size.width - 40, 40)];
        _textField.borderStyle = UITextBorderStyleRoundedRect;
        _textField.autocorrectionType = UITextAutocorrectionTypeNo;
        _textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        _textField.spellCheckingType = UITextSpellCheckingTypeNo;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(searchKeyChange:) name:UITextFieldTextDidChangeNotification object:nil];
    }
    return _textField;
}

- (void)searchKeyChange:(NSNotification *)noti
{
    UITextField * tf = noti.object;
    NSString *title2 = str;
    NSMutableAttributedString *att = [[NSMutableAttributedString alloc]initWithString:title2];
    if (tf.text && tf.text.length > 0) {
        WKSearchStringManager * ssm = [WKSearchStringManager sharedSearchStringManager];
        ssm.searchStr = tf.text;
        ssm.sourceStr = str;
        NSArray <NSValue *> * ranges = [ssm matching];
        for (NSValue * v in ranges) {
            NSRange range = [v rangeValue];
            [att addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:253 / 255.0 green:100 / 255.0 blue:85 / 255.0 alpha:1] range:range];
        }
    }
    self.textLabel.attributedText = att;    
}


@end
