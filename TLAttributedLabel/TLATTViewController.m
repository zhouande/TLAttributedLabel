//
//  ViewController.m
//  TLAttributedLabel
//
//  Created by andezhou on 15/8/8.
//  Copyright (c) 2015年 周安德. All rights reserved.
//

#import "TLATTViewController.h"
#import "TLWebViewController.h"
#import "TLAttributedLabel.h"

@interface TLATTViewController () <TLAttributedLabelDelegate>

@property (nonatomic, strong) TLAttributedLabel *label;

@end

@implementation TLATTViewController

#pragma mark -
#pragma mark lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"TLAttributedLabel";
    self.view.backgroundColor = [UIColor whiteColor];
    
    NSString *str = @"@京东 2014年4月，[/haqian.gif]有网友曝光了一组奶茶妹妹章泽天ss与京东老总刘强东的约会照。 4月7日，刘强东微博Https://www.baidu.com/s?cl=3&tn=baidutop10&fr=top1000&wd=%E5%AD%A6%E7%94%9F%E5%90%88%E5%94%B1%E8%87%B4%E8%88%9E%E5%8F%B0%E5%9D%8D%E5%A1%8C&rsv_idx=2发声，称“我们每个人都有选择和决定自己生活的权利。小天是我见过最单纯善良的人，很遗憾自己没能保护好她。感谢大家关心，只求以后可以正常牵手而行。@奶茶妹妹 [/haha] #开心时刻#”[/haha.gif]";
    
    _label = [[TLAttributedLabel alloc] initWithFrame:CGRectMake(10, 100, [UIScreen mainScreen].bounds.size.width - 20, 400)];
    _label.delegate = self;
//    _label.numberOfLines = 6;
//    _label.showUrl = YES;
    [_label setText:str];
    _label.imageSize = CGSizeMake(20, 20);
    [_label addCustomLink:@"刘强东"];
    CGSize size = [_label sizeThatFits:CGSizeMake([UIScreen mainScreen].bounds.size.width - 20, MAXFLOAT)];
    _label.frame = CGRectMake(10, 100, size.width, size.height);
    
    [self.view addSubview:_label];
    // Do any additional setup after loading the view, typically from a nib.
}

#pragma mark -
#pragma mark TLAttributedLabelDelegate
- (void)attributedLabel:(TLAttributedLabel *)label linkData:(TLAttributedLink *)linkData {
    if (linkData.url) {
        TLWebViewController *webVC = [[TLWebViewController alloc] init];
        webVC.url = linkData.url;
        [self.navigationController pushViewController:webVC animated:YES];
    }else{
        NSString *message = [NSString stringWithFormat:@"您点中: %@", linkData.title];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
