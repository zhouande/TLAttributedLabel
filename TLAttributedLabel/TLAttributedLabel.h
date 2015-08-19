//
//  TLAttributedLabel.h
//  TLAttributedLabel
//
//  Created by andezhou on 15/8/8.
//  Copyright (c) 2015年 周安德. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TLAttributedImage.h"
#import "TLAttributedLink.h"

@class TLAttributedLabel;
@protocol TLAttributedLabelDelegate <NSObject>

@required
- (void)attributedLabel:(TLAttributedLabel *)label linkData:(TLAttributedLink *)linkData;
@end

@interface TLAttributedLabel : UIView

@property (nonatomic, weak) id<TLAttributedLabelDelegate> delegate;

@property (nonatomic, strong)  UIFont           *font;             // 字体
@property (nonatomic, strong)  UIColor          *textColor;        // 文字颜色
@property (nonatomic, strong)  UIColor          *linkColor;        // 文字颜色
@property (nonatomic, strong)  UIColor          *highlightColor;   // 链接点击时背景高亮色

@property (nonatomic, assign)  CGFloat          lineSpacing;       // 行间距
@property (nonatomic, assign)  CGFloat          paragraphSpacing;  // 段间距
@property (nonatomic, assign)  CTTextAlignment  textAlignment;     // 文字排版样式
@property (nonatomic, assign)  CTLineBreakMode  lineBreakMode;     // LineBreakMode

@property (nonatomic, assign)  TLImageAlignment imageAlignment;    // 图片相对于文字的排版样式
@property (nonatomic, assign)  UIEdgeInsets     imageMargin;       // 图片与文字之间的间距

@property (nonatomic, assign)  NSUInteger       numberOfLines;     // 行数
@property (nonatomic, assign)  CGSize           imageSize;         // 图片size，针对文本中所有的图片
@property (nonatomic, assign)  BOOL             showUrl;           // 是否显示网址
@property (nonatomic, assign)  BOOL             autoDetectLinks;   //自动检测link

// 大小
- (CGSize)sizeThatFits:(CGSize)size;

// 普通文本
- (void)setText:(NSString *)text;

// 属性文本
- (void)setAttributedText:(NSAttributedString *)attributedText;

// JSON处理
- (void)parseTemplateArray:(NSArray *)JSON;

// 添加自定义链接
- (void)addCustomLink:(NSString *)link;
- (void)addCustomLink:(NSString *)link
                 font:(UIFont *)font
            linkColor:(UIColor *)color;


@end
