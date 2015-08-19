//
//  TLJSONViewController.m
//  TLAttributedLabel
//
//  Created by andezhou on 15/8/17.
//  Copyright (c) 2015年 andezhou. All rights reserved.
//

#import "TLJSONViewController.h"
#import "TLWebViewController.h"
#import "TLAttributedLabel.h"

@interface TLJSONViewController () <TLAttributedLabelDelegate>

@property (nonatomic, strong) TLAttributedLabel *label;

@end

@implementation TLJSONViewController

#pragma mark -
#pragma mark lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"JSON";
    self.view.backgroundColor = [UIColor whiteColor];
//    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:scrollView];
    
    // 1.从文件中获取数据
    NSString *path = [[NSBundle mainBundle] pathForResource:@"content" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    
    // 2.把二进制文件转化为数组（NSArray）
    NSArray *array = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    
    _label = [[TLAttributedLabel alloc] init];
    [_label parseTemplateArray:array];
    _label.delegate = self;
    CGSize size = [_label sizeThatFits:CGSizeMake([UIScreen mainScreen].bounds.size.width - 20, MAXFLOAT)];
    _label.frame = CGRectMake(10, 10, size.width, size.height);
    scrollView.contentSize = CGSizeMake(size.width, size.height + 20);
    
    [scrollView addSubview:_label];
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

@end
