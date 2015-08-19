//
//  NSMutableAttributedString+LInk.m
//  TLAttributedLabel
//
//  Created by andezhou on 15/8/13.
//  Copyright (c) 2015年 andezhou. All rights reserved.
//

#import <CoreText/CoreText.h>
#import "NSMutableAttributedString+Link.h"
#import "NSMutableAttributedString+Config.h"
#import "NSMutableAttributedString+Picture.h"
#import "TLAttributedLabelConst.h"
#import "TLAttributedLink.h"
#import "TLAttributedImage.h"
#import <objc/runtime.h>

// 检查URL/@/##/手机号
static NSString *const pattern = @"(@([\u4e00-\u9fa5A-Z0-9a-z(é|ë|ê|è|à|â|ä|á|ù|ü|û|ú|ì|ï|î|í)._-]+))|(#[\u4e00-\u9fa5A-Z0-9a-z(é|ë|ê|è|à|â|ä|á|ù|ü|û|ú|ì|ï|î|í)._-]+#)|((http[s]{0,1}|ftp)://[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)|(www.[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)";

@implementation NSMutableAttributedString (Link)
static char urlAttStringKey;

- (NSMutableAttributedString *)urlAttString {
    return objc_getAssociatedObject(self, &urlAttStringKey);
}

- (void)setUrlAttString:(NSMutableAttributedString *)urlAttString {
    objc_setAssociatedObject(self, &urlAttStringKey, urlAttString, OBJC_ASSOCIATION_COPY);
}

// 检查并处理链接
- (NSMutableArray *)setAttributedStringWithFont:(UIFont *)font
                                        showUrl:(BOOL)showUrl
                                      linkColor:(UIColor *)linkColor
                                         images:(NSMutableArray *)images {
    // 初始化用来保存链接的数组
    NSMutableArray *links = [NSMutableArray array];
    
    // 处理@、#、url和手机号码
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:nil];
    [regex enumerateMatchesInString:self.string options:0 range:NSMakeRange(0, self.string.length) usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
        
        NSString *txt = [self.string substringWithRange:result.range];
        TLAttributedLink *linkData = [[TLAttributedLink alloc] init];
        linkData.title = txt;
        [links addObject:linkData];
        
        if (!([linkData.title hasPrefix:@"#"] || [linkData.title hasPrefix:@"@"])) {
            linkData.url = txt;
        }
    }];
    
    // 处理链接
    for (TLAttributedLink *linkData in links) {        
        NSRange range = [self.string rangeOfString:linkData.title];
        linkData.range = range;

        // 设置颜色和字体大小
        [self setFont:font range:range];
        [self setTextColor:linkColor range:range];
        
        if (!([linkData.title hasPrefix:@"#"] || [linkData.title hasPrefix:@"@"]) && !showUrl) {
            NSMutableAttributedString *urlAttString = [self addUrlAttStringWithLinkData:linkData font:font linkColor:linkColor  images:images];

            [self replaceCharactersInRange:range withAttributedString:urlAttString];
            linkData.title = TLReplaceURLTitle;
            linkData.range = NSMakeRange(range.location + 1, urlAttString.length - 2);
        }
    }
    
    return links;
}

- (NSMutableAttributedString *)addUrlAttStringWithLinkData:(TLAttributedLink *)linkData
                                                      font:(UIFont *)font
                                                 linkColor:(UIColor *)linkColor
                                                    images:(NSMutableArray *)images {
    if (!self.urlAttString) {
        // 设置图片属性
        TLAttributedImage *imageData = [[TLAttributedImage alloc] init];
        imageData.imageName = TLReplaceURLImageName;
        imageData.type = TLImagePNGTppe;
        imageData.imageSize = CGSizeMake(font.pointSize, font.pointSize);
        imageData.fontRef = CTFontCreateWithName((CFStringRef)font.fontName, font.pointSize, NULL);
        imageData.imageAlignment = TLImageAlignmentCenter;
        imageData.imageMargin = UIEdgeInsetsZero;
        [images addObject:imageData];
        
        // 创建图片带属性字符串
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@" "];
        NSAttributedString *imageAttString = [self createImageAttributedString:imageData];
        [attributedString appendAttributedString:imageAttString];

        // 生成完成的链接
        NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:TLReplaceURLTitle];
        [attributedString appendAttributedString:attString];
        [attributedString appendAttributedString:[[NSMutableAttributedString alloc] initWithString:@" "]];
                
        // 设置颜色和字体大小
        [attributedString setFont:font];
        [attributedString setTextColor:linkColor];
        
        self.urlAttString = [attributedString mutableCopy];
    }
    
    return self.urlAttString;
}

#pragma mark -
#pragma mark 添加自定义链接
static NSUInteger kLocation = 0;
- (NSArray *)setCustomLink:(NSString *)link
                      font:(UIFont *)font
                 linkColor:(UIColor *)color {
    kLocation = 0;
    // 检查可变字符串中的所有link
    NSMutableArray *customLinks = [NSMutableArray array];
    [self checkCustomLink:link string:self.string customLinks:customLinks];
    
    // 遍历所有满足条件的link，如果range跟link一致，着添加自定义链接
    for (TLAttributedLink *customLinkData in customLinks) {
        [self setFont:font range:customLinkData.range];
        [self setTextColor:color range:customLinkData.range];
    }
    
    return customLinks;
}

// 检查可变字符串中的所有link
- (void)checkCustomLink:(NSString *)link
                 string:(NSString *)string
            customLinks:(NSMutableArray *)customLinks {
    NSRange range = [string rangeOfString:link];

    if (range.location != NSNotFound) {
        TLAttributedLink *linkData = [[TLAttributedLink alloc] init];
        linkData.title = link;
        linkData.range = NSMakeRange(kLocation + range.location, range.length);
        [customLinks addObject:linkData];
        
        // 递归继续查询
        NSString *result = [string substringFromIndex:range.location + range.length];
        kLocation += range.location + range.length;
        [self checkCustomLink:link string:result customLinks:customLinks];
    }
}

@end
