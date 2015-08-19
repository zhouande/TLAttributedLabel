//
//  TLTableViewCell.h
//  TLAttributedLabel
//
//  Created by andezhou on 15/8/12.
//  Copyright (c) 2015年 周安德. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TLAttributedLabel;
@class TLModel;

static CGFloat const kMargin = 10.f;
static NSUInteger const numberOfLines = 5;

@interface TLTableViewCell : UITableViewCell

@property (nonatomic, strong) TLModel *model;
@property (nonatomic, strong) TLAttributedLabel *label;

@end
