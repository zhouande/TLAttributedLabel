//
//  NSMutableAttributedString+CTFrameRef.m
//  TLAttributedLabel
//
//  Created by andezhou on 15/8/8.
//  Copyright (c) 2015年 周安德. All rights reserved.
//

#import "NSMutableAttributedString+CTFrameRef.h"
#import "TLAttributedImage.h"

@implementation NSMutableAttributedString (CTFrameRef)

#pragma mark - NSRange / CFRange
NSRange NSRangeFromCFRange(CFRange range) {
    return NSMakeRange((NSUInteger)range.location, (NSUInteger)range.length);
}

#pragma mark - CoreText CTLine/CTRun utils
BOOL CTRunContainsCharactersFromStringRange(CTRunRef run, NSRange range) {
    NSRange runRange = NSRangeFromCFRange(CTRunGetStringRange(run));
    NSRange intersectedRange = NSIntersectionRange(runRange, range);
    return (intersectedRange.length <= 0);
}

BOOL CTLineContainsCharactersFromStringRange(CTLineRef line, NSRange range) {
    NSRange lineRange = NSRangeFromCFRange(CTLineGetStringRange(line));
    NSRange intersectedRange = NSIntersectionRange(lineRange, range);
    return (intersectedRange.length <= 0);
}

CGRect CTRunGetTypographicBoundsAsRect(CTRunRef run, CTLineRef line, CGPoint lineOrigin) {
    CGFloat ascent = 0.f;
    CGFloat descent = 0.f;
    CGFloat leading = 0.f;
    CGFloat width = (CGFloat)CTRunGetTypographicBounds(run, CFRangeMake(0, 0), &ascent, &descent, &leading);
    CGFloat height = ascent + descent;
    
    CGFloat xOffset = CTLineGetOffsetForStringIndex(line, CTRunGetStringRange(run).location, NULL);
    
    return CGRectMake(lineOrigin.x + xOffset - leading,
                      lineOrigin.y - descent,
                      width + leading,
                      height);
}

CGFloat CTLineGetTypographicBoundsAsWidth(CTLineRef line) {
    CGFloat ascent = 0.f;
    CGFloat descent = 0.f;
    CGFloat leading = 0.f;
    CGFloat width = (CGFloat)CTLineGetTypographicBounds(line, &ascent, &descent, &leading);
    
    return width;
}

CGRect CTLineGetTypographicBoundsAsRect(CTLineRef line, CGPoint lineOrigin) {
    CGFloat ascent = 0.f;
    CGFloat descent = 0.f;
    CGFloat leading = 0.f;
    CGFloat width = (CGFloat)CTLineGetTypographicBounds(line, &ascent, &descent, &leading);
    CGFloat height = ascent + descent;
    
    return CGRectMake(lineOrigin.x,
                      lineOrigin.y - descent,
                      width,
                      height);
}

CGRect CTRunGetTypographicBoundsForLinkRect(CTLineRef line, NSRange range, CGPoint lineOrigin) {
    CGRect rectForRange = CGRectZero;
    CFArrayRef runs = CTLineGetGlyphRuns(line);
    CFIndex runCount = CFArrayGetCount(runs);
    
    for (CFIndex k = 0; k < runCount; k++) {
        CTRunRef run = CFArrayGetValueAtIndex(runs, k);
        
        if (CTRunContainsCharactersFromStringRange(run, range)) {
            continue;
        }
        
        CGRect linkRect = CTRunGetTypographicBoundsAsRect(run, line, lineOrigin);
        
        linkRect.origin.y = roundf(linkRect.origin.y);
        linkRect.origin.x = roundf(linkRect.origin.x);
        linkRect.size.width = roundf(linkRect.size.width);
        linkRect.size.height = roundf(linkRect.size.height);
        
        rectForRange = CGRectIsEmpty(rectForRange) ? linkRect : CGRectUnion(rectForRange, linkRect);
    }
    
    return rectForRange;
}

CGRect CTRunGetTypographicBoundsForImageRect(CTRunRef run, CTLineRef line, CGPoint lineOrigin, TLAttributedImage *imageData) {
    CGRect runBounds = CGRectZero;
    
    CGFloat ascent = 0.f;
    CGFloat descent = 0.f;
    CGFloat leading = 0.f;
    
    CGFloat width = CTRunGetTypographicBounds(run, CFRangeMake(0, 0), &ascent, &descent, &leading);
    CGFloat lineHeight = ascent + descent + leading;
    CGFloat lineBottomY = lineOrigin.y - descent;
    
    runBounds.size.width = width;
    runBounds.size.height = imageData.imageSize.height;
    
    CGFloat xOffset = CTLineGetOffsetForStringIndex(line, CTRunGetStringRange(run).location, NULL);
    runBounds.origin.x = lineOrigin.x + xOffset;
    
    // 设置Y坐标
    CGFloat imagePointY = 0.f;
    CGFloat imageBoxHeight = imageData.imageSize.height;
    switch (imageData.imageAlignment) {
        case TLImageAlignmentTop:
            imagePointY = lineBottomY + (lineHeight - imageBoxHeight);
            break;
        case TLImageAlignmentCenter:
            imagePointY = lineBottomY + (lineHeight - imageBoxHeight) / 2.f;
            break;
        case TLImageAlignmentBottom:
            imagePointY = lineBottomY;
            break;
    }
    runBounds.origin.y = imagePointY;
    
    return UIEdgeInsetsInsetRect(runBounds, imageData.imageMargin);
}

#pragma mark -
#pragma mark 获取CTFrameRef
- (CTFrameRef)prepareFrameRefWithRect:(CGRect)rect {
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)self);
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, nil, rect);
    CTFrameRef frameRef = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), path, NULL);
    
    CGPathRelease(path);
    CFRelease(framesetter);
    
    return frameRef;
}

- (CTFrameRef)createFrameWithFramesetter:(CTFramesetterRef)framesetter
                                   width:(CGFloat)width
                                  height:(CGFloat)height {
    CGMutablePathRef pathRef = CGPathCreateMutable();
    CGPathAddRect(pathRef, NULL, CGRectMake(0, 0, width, height));
    
    CTFrameRef frameRef = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), pathRef, NULL);
    CFRelease(pathRef);
    
    return frameRef;
}

#pragma mark -
#pragma mark 获取label高度
- (CGSize)boundingSizeForWidth:(CGFloat)width {
    return [self boundingSizeForWidth:width numberOfLines:0];
}

- (CGSize)boundingSizeForWidth:(CGFloat)width
                    numberOfLines:(NSUInteger)numberOfLines {
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)self);
    CFRange range = CFRangeMake(0, 0);
    
    if (numberOfLines > 0 && framesetter) {
        CTFrameRef frameRef = [self createFrameWithFramesetter:framesetter width:width height:MAXFLOAT];
        CFArrayRef lines = CTFrameGetLines(frameRef);
        CFIndex lineCount = CFArrayGetCount(lines);

        if (nil != lines && lineCount > 0) {
            NSInteger lastVisibleLineIndex = MIN(numberOfLines, lineCount) - 1;
            CTLineRef lastVisibleLine = CFArrayGetValueAtIndex(lines, lastVisibleLineIndex);
            
            CFRange rangeToLayout = CTLineGetStringRange(lastVisibleLine);
            range = CFRangeMake(0, rangeToLayout.location + rangeToLayout.length);
        }
        CFRelease(frameRef);
    }
    
    // range表示计算绘制文字的范围，当值为zero时表示绘制全部文字
    CGSize newSize = CTFramesetterSuggestFrameSizeWithConstraints(framesetter, range, NULL, CGSizeMake(width, MAXFLOAT), NULL);
    return CGSizeMake(newSize.width + 1, newSize.height + 1);
}

@end
