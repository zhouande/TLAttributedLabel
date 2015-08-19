//
//  NSMutableAttributedString+Config.m
//  TLAttributedLabel
//
//  Created by andezhou on 15/8/8.
//  Copyright (c) 2015年 周安德. All rights reserved.
//

#import "NSMutableAttributedString+Config.h"
#import "TLAttributedLabelConst.h"
#import "UIImageView+GIF.h"
#import <CoreText/CoreText.h>

@implementation NSMutableAttributedString (Config)

// 根据JSON中的color转化为UIColor
UIColor * TLColorFromString(NSString *colorString, UIColor *defaultColor) {
    if (colorString) {
        return [UIColor colorWithHexString:colorString];
    } else {
        return defaultColor;
    }
}

// 设置字体大小
UIFont * TLFontFromString(NSString *fontString, UIFont *defaultFont) {
    if (fontString) {
        return [UIFont systemFontOfSize:[fontString floatValue]];
    }else {
        return defaultFont;
    }
}

// lineSpacing
CGFloat TLLineSpacingFromString(NSString *lineSpacing, CGFloat defaultLineSpacing) {
    if (lineSpacing) {
        return [lineSpacing floatValue];
    }else {
        return defaultLineSpacing;
    }
}

// paragraphSpacing
CGFloat TLParagraphSpacingFromString(NSString *paragraphSpacing, CGFloat defaultParagraphSpacing) {
    if (paragraphSpacing) {
        return [paragraphSpacing floatValue];
    }else {
        return defaultParagraphSpacing;
    }
}

// textAlignment
CTTextAlignment TLTextAlignmentFromString(NSString *textAlignment, CGFloat defaultTextAlignment) {
    if ([textAlignment isEqualToString:TLJSONTextAlignmentRightValue]) {
        return kCTTextAlignmentRight;
    } else if ([textAlignment isEqualToString:TLJSONTextAlignmentCenterValue]) {
        return kCTTextAlignmentCenter;
    } else if ([textAlignment isEqualToString:TLJSONTextAlignmentJustifiedValue]) {
        return kCTTextAlignmentJustified;
    } else if ([textAlignment isEqualToString:TLJSONTextAlignmentNaturalValue]) {
        return kCTTextAlignmentNatural;
    } else {
        return kCTTextAlignmentLeft;
    }
}

// 设置颜色
- (void)setTextColor:(UIColor *)color {
    [self setTextColor:color range:NSMakeRange(0, [self length])];
}

- (void)setTextColor:(UIColor *)color range:(NSRange)range {
    if (color.CGColor) {
        [self removeAttribute:(NSString *)kCTForegroundColorAttributeName range:range];
        
        [self addAttribute:(NSString *)kCTForegroundColorAttributeName
                     value:(id)color.CGColor
                     range:range];
    }
}

// 设置字体
- (void)setFont:(UIFont *)font {
    [self setFont:font range:NSMakeRange(0, [self length])];
}

- (void)setFont:(UIFont *)font range:(NSRange)range {
    if (font) {
        [self removeAttribute:(NSString*)kCTFontAttributeName range:range];
        
        CTFontRef fontRef = CTFontCreateWithName((CFStringRef)font.fontName, font.pointSize, nil);
        if (nil != fontRef) {
            [self addAttribute:(NSString *)kCTFontAttributeName value:(__bridge id)fontRef range:range];
            CFRelease(fontRef);
        }
    }
}

// 设置下划线
- (void)setUnderlineStyle:(CTUnderlineStyle)style
                 modifier:(CTUnderlineStyleModifiers)modifier {
    [self setUnderlineStyle:style
                   modifier:modifier
                      range:NSMakeRange(0, self.length)];
}

- (void)setUnderlineStyle:(CTUnderlineStyle)style
                 modifier:(CTUnderlineStyleModifiers)modifier
                    range:(NSRange)range {
    [self removeAttribute:(NSString *)kCTUnderlineColorAttributeName range:range];
    [self addAttribute:(NSString *)kCTUnderlineStyleAttributeName
                 value:[NSNumber numberWithInt:(style|modifier)]
                 range:range];
    
}

// 设置属性
- (NSDictionary *)setAttributedsWithLineSpacing:(CGFloat)lineSpacing
                                            paragraphSpacing:(CGFloat)paragraphSpacing
                                               textAlignment:(CTTextAlignment)textAlignment
                                               lineBreakMode:(CTLineBreakMode)lineBreakMode {
    const CFIndex kNumberOfSettings = 6;
    CTParagraphStyleSetting theSettings[kNumberOfSettings] = {
        {kCTParagraphStyleSpecifierLineBreakMode, sizeof(uint8_t), &lineBreakMode},
        {kCTParagraphStyleSpecifierAlignment, sizeof(uint8_t), &textAlignment},
        {kCTParagraphStyleSpecifierParagraphSpacing, sizeof(CGFloat), &paragraphSpacing},
        {kCTParagraphStyleSpecifierLineSpacingAdjustment, sizeof(CGFloat), &lineSpacing},
        {kCTParagraphStyleSpecifierMaximumLineSpacing, sizeof(CGFloat), &lineSpacing},
        {kCTParagraphStyleSpecifierMinimumLineSpacing, sizeof(CGFloat), &lineSpacing}
    };
    
    CTParagraphStyleRef theParagraphRef = CTParagraphStyleCreate(theSettings, kNumberOfSettings);
    
    // 生成带属性的字符串的attributes
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    attributes[(id)kCTParagraphStyleAttributeName] = (__bridge id)theParagraphRef;

    CFRelease(theParagraphRef);
    
    return (NSDictionary *)attributes;
}

- (NSDictionary *)setAttributedsWithDict:(NSDictionary *)dict
                             LineSpacing:(CGFloat)lineSpacing
                        paragraphSpacing:(CGFloat)paragraphSpacing
                           textAlignment:(CTTextAlignment)textAlignment
                           lineBreakMode:(CTLineBreakMode)lineBreakMode {
    // 行间距
    CGFloat newLineSpacing            = TLLineSpacingFromString(dict[TLJSONLineSpacingKey], lineSpacing);
    // 段间距
    CGFloat newParagraphSpacing       = TLParagraphSpacingFromString(dict[TLJSONParagraphSpacingKey], paragraphSpacing);
    // 文本对齐方式
    CTTextAlignment newTextAlignment  = TLTextAlignmentFromString(dict[TLJSONTextAlignmentKey], textAlignment);
    // 生成带属性的字符串的
    NSDictionary *attributes = [self setAttributedsWithLineSpacing:newLineSpacing
                                                  paragraphSpacing:newParagraphSpacing
                                                     textAlignment:newTextAlignment
                                                     lineBreakMode:lineBreakMode];
    return attributes;
}

@end
