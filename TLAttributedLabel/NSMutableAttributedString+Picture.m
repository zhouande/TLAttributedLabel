//
//  NSMutableAttributedString+Picture.m
//  TLAttributedLabel
//
//  Created by andezhou on 15/8/12.
//  Copyright (c) 2015年 andezhou. All rights reserved.
//

#import "NSMutableAttributedString+Picture.h"
#import "TLAttributedLabelConst.h"
#import <CoreText/CoreText.h>

@implementation NSMutableAttributedString (Picture)

// 获取图片高度
static CGFloat ascentCallback(void *ref) {
    TLAttributedImage *imageData = (__bridge TLAttributedImage*)ref;
    CGFloat height = attributedImageSize(imageData).height;
    
    CGFloat ascent = 0;
    CGFloat fontAscent  = CTFontGetAscent(imageData.fontRef);
    CGFloat fontDescent = CTFontGetDescent(imageData.fontRef);
    
    switch (imageData.imageAlignment){
        case TLImageAlignmentTop:
            ascent = fontAscent;
            break;
        case TLImageAlignmentCenter:{
            CGFloat baseLine = (fontAscent + fontDescent) / 2 - fontDescent;
            ascent = height / 2 + baseLine;
        }
            break;
        case TLImageAlignmentBottom:
            ascent = height - fontDescent;
            break;
        default:
            break;
    }
    return ascent;
}

// 调整图片对齐方式
static CGFloat descentCallback(void *ref) {
    TLAttributedImage *imageData = (__bridge TLAttributedImage*)ref;
    CGFloat height = attributedImageSize(imageData).height;
    
    if (!height) return 0;
    CGFloat descent = 0;
    CGFloat fontAscent  = CTFontGetAscent(imageData.fontRef);
    CGFloat fontDescent = CTFontGetDescent(imageData.fontRef);

    switch (imageData.imageAlignment) {
        case TLImageAlignmentTop:{
            descent = height - fontAscent;
            break;
        }
        case TLImageAlignmentCenter:{
            CGFloat baseLine = (fontAscent + fontDescent) / 2.f - fontDescent;
            descent = height / 2.f - baseLine;
        }
            break;
        case TLImageAlignmentBottom:{
            descent = fontDescent;
            break;
        }
        default:
            break;
    }
    
    return descent;
}

// 获取图片宽度
static CGFloat widthCallback(void *ref) {
    TLAttributedImage *imageData = (__bridge TLAttributedImage*)ref;
    return attributedImageSize(imageData).width;
}

static CGSize attributedImageSize(TLAttributedImage *imageData) {
    return CGSizeMake(imageData.imageSize.width + imageData.imageMargin.left + imageData.imageMargin.right,
                      imageData.imageSize.height+ imageData.imageMargin.top  + imageData.imageMargin.bottom);
}

// 创建图片attString
- (NSMutableAttributedString *)createImageAttributedString:(TLAttributedImage *)imageData {
    CTRunDelegateCallbacks callbacks;
    memset(&callbacks, 0, sizeof(CTRunDelegateCallbacks));
    callbacks.version = kCTRunDelegateVersion1;
    callbacks.getAscent = ascentCallback;
    callbacks.getDescent = descentCallback;
    callbacks.getWidth = widthCallback;

    // 创建CTRun回调
    CTRunDelegateRef runDelegate = CTRunDelegateCreate(&callbacks, (__bridge void *)(imageData));
    
    // 使用 0xFFFC 作为空白的占位符
    unichar objectReplacementChar = 0xFFFC;
    NSString *string = [NSString stringWithCharacters:&objectReplacementChar length:1];
    
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:string];
    [attString addAttribute:(NSString *)kCTRunDelegateAttributeName value:(__bridge id)runDelegate range:NSMakeRange(0, 1)];

    CFRelease(runDelegate);
    
    return attString;
}

// 检查并处理图片
- (NSMutableArray *)setImageAlignment:(TLImageAlignment)imageAlignment
                          imageMargin:(UIEdgeInsets)imageMargin
                            imageSize:(CGSize)imageSize
                                 font:(UIFont *)font {
    NSMutableArray *images = [NSMutableArray array];

    // 通过递归查询出所有的图片
    [self detectImagesInString:self.string images:images imageAlignment:imageAlignment];
    
    // 替换图片
    CTFontRef fontRef = CTFontCreateWithName((CFStringRef)font.fontName, font.pointSize, NULL);
    for (TLAttributedImage *imageData in images) {
        UIImage *image = [UIImage imageNamed:imageData.imageName];
        
        // 判断图片是否存在
        if (!image) {
            continue;
        }
        
        // 设置图片size
        if (CGSizeEqualToSize(imageSize, CGSizeZero)) {
            imageData.imageSize = CGSizeMake(font.pointSize, font.pointSize);
        }else {
            imageData.imageSize = imageSize;
        }

        // 设置fontRef,方便设置图片位置
        imageData.fontRef = fontRef;
        imageData.imageMargin = imageMargin;
        
        // 设置类型，可为UIImage和UIView
        if ([imageData.imageName rangeOfString:@".gif"].location == NSNotFound) {
            imageData.type = TLImagePNGTppe;
        }else {
            imageData.type = TLImageGIFTppe;
        }

        // 获取图片imageAttString
        NSMutableAttributedString *imageAttString = [self createImageAttributedString:imageData];
        
        // imageAttString替换文字AttString
        NSString *imageStr = [NSString stringWithFormat:@"%@%@%@", TLPictureBeginFlag, imageData.imageName, TLPictureEndFlag];
        NSRange range = [self.string rangeOfString:imageStr];
        
        // 图片替换
        [self replaceCharactersInRange:range withAttributedString:imageAttString];
    }
    
    // 返回包含图片的数组
    return images;
}

// 递归查询出所有的图片
- (void)detectImagesInString:(NSString *)string
                      images:(NSMutableArray *)images
              imageAlignment:(TLImageAlignment)imageAlignment {
   
    NSRange range1 = [string rangeOfString:TLPictureBeginFlag];
    NSRange range2 = [string rangeOfString:TLPictureEndFlag];
    
    // 开始查找
    if (range2.location != NSNotFound && range1.location != NSNotFound) {
        NSUInteger location = range1.location + range1.length;
        NSUInteger length = range2.location - location;

        // 图片名
        NSString *imageName = [string substringWithRange:NSMakeRange(location, length)];
        
        // 初始化图片数据模型
        TLAttributedImage *imageData = [[TLAttributedImage alloc] init];
        imageData.imageName = imageName;
        imageData.imageAlignment = imageAlignment;
        
        // 添加到图片数组
        [images addObject:imageData];
        
        // 递归继续查询
        NSString *result = [string substringFromIndex:range2.location + range2.length];
        [self detectImagesInString:result images:images imageAlignment:imageAlignment];
    }
}

@end
