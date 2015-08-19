//
//  NSMutableAttributedString+Picture.h
//  TLCoreTextMore
//
//  Created by andezhou on 15/8/12.
//  Copyright (c) 2015年 andezhou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TLAttributedImage.h"

@interface NSMutableAttributedString (Picture)

// 检查并处理图片
- (NSMutableArray *)setImageAlignment:(TLImageAlignment)imageAlignment
                          imageMargin:(UIEdgeInsets)imageMargin
                            imageSize:(CGSize)imageSize
                                 font:(UIFont *)font;

// 创建图片attString
- (NSMutableAttributedString *)createImageAttributedString:(TLAttributedImage *)imageData;

@end
