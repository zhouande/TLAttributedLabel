//
//  TLAttributedLabel.h
//  TLAttributedLabel
//
//  Created by andezhou on 15/7/29.
//  Copyright (c) 2015年 andezhou. All rights reserved.
//

#import "TLAttributedLabelUtils.h"
#import "NSMutableAttributedString+CTFrameRef.h"
#import "TLAttributedLink.h"

static const CGFloat kMargin = 5;

@implementation TLAttributedLabelUtils

// 将点击的位置转换成字符串的偏移量，如果没有找到，则返回-1
+ (CFIndex)touchContentOffsetInView:(UIView *)view atPoint:(CGPoint)point ctFrame:(CTFrameRef)ctFrame {
    // 获取CFArrayRef
    CTFrameRef textFrame = ctFrame;
    CFArrayRef lines = CTFrameGetLines(textFrame);
    
    if (!lines) return -1;
    
    CFIndex count = CFArrayGetCount(lines);
    
    CGPoint origins[count];
    CTFrameGetLineOrigins(textFrame, CFRangeMake(0, 0), origins);

    // 翻转坐标系
    CGAffineTransform transform =  CGAffineTransformMakeTranslation(0, view.bounds.size.height);
    transform = CGAffineTransformScale(transform, 1.f, -1.f);
    
    CFIndex idx = -1;
    for (CFIndex index = 0; index < count; index ++) {
        CGPoint linePoint = origins[index];
        
        CTLineRef line = CFArrayGetValueAtIndex(lines, index);
        
        CGRect flippedRect = CTLineGetTypographicBoundsAsRect(line, linePoint);
        CGRect rect = CGRectApplyAffineTransform(flippedRect, transform);
        rect = CGRectInset(rect, 0, -kMargin);

        if (CGRectContainsPoint(rect, point)) {
            // 将点击的坐标转换成相对于当前行的坐标
            CGPoint relativePoint = CGPointMake(point.x - CGRectGetMinX(rect),
                                                point.y - CGRectGetMinY(rect));
            // 获取点击位置所处的字符位置，就是相当于点击了第几个字符
            idx = CTLineGetStringIndexForPosition(line, relativePoint);
        }
    }
    return idx;
}

// 检测点击位置是否在链接上
+ (TLAttributedLink *)touchLinkInView:(UIView *)view
                                links:(NSArray *)links
                                point:(CGPoint)point
                             frameRef:(CTFrameRef)frameRef {
    CFIndex idx = [self touchContentOffsetInView:view point:point frameRef:frameRef];
    
    if (idx == -1) return nil;
    
    // 返回被选中的链接所对应的数据模型，如果没选中foundLink为nil
    return [self linkAtIndex:idx links:links];;
}

// 将点击的位置转换成字符串的偏移量，如果没有找到，则返回-1
+ (CFIndex)touchContentOffsetInView:(UIView *)view
                              point:(CGPoint)point
                           frameRef:(CTFrameRef)frameRef {
    // 获取CFArrayRef
    CFArrayRef lines = CTFrameGetLines(frameRef);
    
    if (!lines) return -1;
    
    CFIndex count = CFArrayGetCount(lines);
    
    CGPoint origins[count];
    CTFrameGetLineOrigins(frameRef, CFRangeMake(0,0), origins);
    
    // 翻转坐标系
    CGAffineTransform transform =  CGAffineTransformMakeTranslation(0, view.bounds.size.height);
    transform = CGAffineTransformScale(transform, 1.f, -1.f);
    
    CFIndex idx = -1;
    for (NSInteger index = 0; index < count; index++) {
        CGPoint linePoint = origins[index];
        
        CTLineRef line = CFArrayGetValueAtIndex(lines, index);
        CGRect flippedRect = CTLineGetTypographicBoundsAsRect(line, linePoint);
        
        CGRect rect = CGRectApplyAffineTransform(flippedRect, transform);
        // 容错保护
        rect = CGRectMake(CGRectGetMinX(rect), CGRectGetMinY(rect) - 3, CGRectGetWidth(rect), CGRectGetHeight(rect) + 6);
        
        if (CGRectContainsPoint(rect, point)) {
            // 将点击的坐标转换成相对于当前行的坐标
            CGPoint relativePoint = CGPointMake(point.x - CGRectGetMinX(rect), point.y - CGRectGetMinY(rect));
            // 获取点击位置所处的字符位置，就是相当于点击了第几个字符
            idx = CTLineGetStringIndexForPosition(line, relativePoint);
        }
    }
    return idx;
}

+ (TLAttributedLink *)linkAtIndex:(CFIndex)index links:(NSArray *)links {
    TLAttributedLink *link = nil;
    
    for (TLAttributedLink *linkData in links) {
        // 如果index在data.range中，这证明点中链接
        if (NSLocationInRange(index, linkData.range)) {
            link = linkData;
            break;
        }
    }
    return link;
}


@end
