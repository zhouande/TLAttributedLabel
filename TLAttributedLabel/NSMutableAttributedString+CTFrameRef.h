//
//  NSMutableAttributedString+CTFrameRef.h
//  TLAttributedLabel
//
//  Created by andezhou on 15/8/8.
//  Copyright (c) 2015年 周安德. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreText/CoreText.h>
@class TLAttributedImage;

@interface NSMutableAttributedString (CTFrameRef)

#pragma mark - NSRange / CFRange
NSRange NSRangeFromCFRange(CFRange range);

#pragma mark - CoreText CTLine/CTRun utils
BOOL CTRunContainsCharactersFromStringRange(CTRunRef run, NSRange range);
BOOL CTLineContainsCharactersFromStringRange(CTLineRef line, NSRange range);

CGFloat CTLineGetTypographicBoundsAsWidth(CTLineRef line);

CGRect CTRunGetTypographicBoundsAsRect(CTRunRef run, CTLineRef line, CGPoint lineOrigin);
CGRect CTLineGetTypographicBoundsAsRect(CTLineRef line, CGPoint lineOrigin);
CGRect CTRunGetTypographicBoundsForLinkRect(CTLineRef line, NSRange range, CGPoint lineOrigin);
CGRect CTRunGetTypographicBoundsForImageRect(CTRunRef run, CTLineRef line, CGPoint lineOrigin, TLAttributedImage *imageData);

// 获取CTFrameRef
- (CTFrameRef)prepareFrameRefWithRect:(CGRect)rect;

// 获取label高度
- (CGSize)boundingSizeForWidth:(CGFloat)width;

// 获取固定行数的高度
- (CGSize)boundingSizeForWidth:(CGFloat)width
                    numberOfLines:(NSUInteger)numberOfLines;

@end
