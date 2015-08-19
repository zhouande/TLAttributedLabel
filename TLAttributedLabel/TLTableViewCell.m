//
//  TLTableViewCell.m
//  TLAttributedLabel
//
//  Created by andezhou on 15/8/12.
//  Copyright (c) 2015年 周安德. All rights reserved.
//

#import "TLTableViewCell.h"
#import "TLWebViewController.h"
#import "TLAttributedLabel.h"
#import "TLAppDelegate+Helper.h"
#import "TLAppDelegate.h"
#import "TLModel.h"

@interface TLTableViewCell () <TLAttributedLabelDelegate>
@end

@implementation TLTableViewCell

#pragma mark -
#pragma mark init methods
- (TLAttributedLabel *)label {
    if (!_label) {
        _label = [[TLAttributedLabel alloc] init];
        _label.delegate = self;
        _label.backgroundColor = [UIColor whiteColor];
    }
    return _label;
}

#pragma mark -
#pragma mark lifecycle
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.label];
    }
    return self;
}

- (void)setModel:(TLModel *)model {
    _model = model;
    
    _label.numberOfLines = model.numberOfLines;
    [_label setText:model.title];
    _label.imageSize = CGSizeMake(20, 20);
    CGSize size = [_label sizeThatFits:CGSizeMake([UIScreen mainScreen].bounds.size.width - 2*kMargin, MAXFLOAT)];
    _label.frame = CGRectMake(kMargin, kMargin, size.width, size.height);
}

#pragma mark -
#pragma mark TLAttributedLabelDelegate
- (void)attributedLabel:(TLAttributedLabel *)label linkData:(TLAttributedLink *)linkData {
    if (linkData.url) {
        TLAppDelegate *delegate = (TLAppDelegate *)[[UIApplication sharedApplication] delegate];
        UINavigationController *controller = (UINavigationController *)[delegate topMostController];
        
        TLWebViewController *webVC = [[TLWebViewController alloc] init];
        webVC.url = linkData.url;
        [controller pushViewController:webVC animated:YES];
    }else{
        NSString *message = [NSString stringWithFormat:@"您点中: %@", linkData.title];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
    }
}


@end
