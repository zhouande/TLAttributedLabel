//
//  NSMutableAttributedString+Config.h
//  TLAttributedLabel
//
//  Created by andezhou on 15/8/8.
//  Copyright (c) 2015年 周安德. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreText/CoreText.h>

@interface NSMutableAttributedString (Config)

// 根据JSON中的color转化为UIColor
UIColor * TLColorFromString(NSString *colorString, UIColor *defaultColor);
// 设置字体大小
UIFont * TLFontFromString(NSString *fontString, UIFont *defaultFont);

// 设置颜色
- (void)setTextColor:(UIColor *)color;
- (void)setTextColor:(UIColor *)color range:(NSRange)range;

// 设置字体
- (void)setFont:(UIFont *)font;
- (void)setFont:(UIFont *)font range:(NSRange)range;

// 设置下划线
- (void)setUnderlineStyle:(CTUnderlineStyle)style
                 modifier:(CTUnderlineStyleModifiers)modifier;
- (void)setUnderlineStyle:(CTUnderlineStyle)style
                 modifier:(CTUnderlineStyleModifiers)modifier
                    range:(NSRange)range;

// 设置属性
- (NSDictionary *)setAttributedsWithLineSpacing:(CGFloat)lineSpacing
                               paragraphSpacing:(CGFloat)paragraphSpacing
                                  textAlignment:(CTTextAlignment)textAlignment
                                  lineBreakMode:(CTLineBreakMode)lineBreakMode;
- (NSDictionary *)setAttributedsWithDict:(NSDictionary *)dict
                             LineSpacing:(CGFloat)lineSpacing
                        paragraphSpacing:(CGFloat)paragraphSpacing
                           textAlignment:(CTTextAlignment)textAlignment
                           lineBreakMode:(CTLineBreakMode)lineBreakMode;

@end
