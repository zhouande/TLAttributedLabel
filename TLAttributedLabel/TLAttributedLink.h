//
//  TLAttributedLink.h
//  TLAttributedLabel
//
//  Created by andezhou on 15/8/13.
//  Copyright (c) 2015年 andezhou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TLAttributedLink : NSObject

@property (nonatomic, copy)   NSString *title; // 显示的内容

@property (nonatomic, copy)   NSString *url;   // 网址链接

@property (nonatomic, assign) NSRange  range;  // link在文本中的位置

@property (nonatomic, assign) BOOL     showUrl; // 是否显示网址

@end
