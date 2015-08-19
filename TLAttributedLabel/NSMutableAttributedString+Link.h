//
//  NSMutableAttributedString+LInk.h
//  TLCoreTextMore
//
//  Created by andezhou on 15/8/13.
//  Copyright (c) 2015年 andezhou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class TLAttributedLink;

@interface NSMutableAttributedString (Link)

// 检查并处理链接
- (NSMutableArray *)setAttributedStringWithFont:(UIFont *)font
                                        showUrl:(BOOL)showUrl
                                      linkColor:(UIColor *)linkColor
                                         images:(NSMutableArray *)images;
//添加自定义链接
- (NSArray *)setCustomLink:(NSString *)link
                      font:(UIFont *)font
                 linkColor:(UIColor *)color;

@end
