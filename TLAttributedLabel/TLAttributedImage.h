//
//  TLAttributedImage.h
//  TLAttributedLabel
//
//  Created by andezhou on 15/8/13.
//  Copyright (c) 2015年 andezhou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreText/CoreText.h>
/**
 同一行文图混搭时，图片相对于同一行的文字的对齐模式，包含（上、中、下对齐）
 */
typedef NS_ENUM(NSInteger, TLImageAlignment){
    TLImageAlignmentTop = 0,
    TLImageAlignmentCenter,
    TLImageAlignmentBottom,
};

/**
 显示的类型，包括UIImage, UIImageView(gif), 网络获取图片
 */
typedef NS_ENUM(NSInteger, TLImageTppe){
    TLImagePNGTppe = 0,
    TLImageGIFTppe,
    TLImageURLType
};

@interface TLAttributedImage : NSObject

@property (nonatomic, copy)   NSString *imageName;  // 图片名字

@property (nonatomic, assign) CGSize imageSize;     // 图片大小

@property (nonatomic, assign) CTFontRef fontRef;    // 文字字体

@property (nonatomic, assign) TLImageTppe type;     // 显示的类型

@property (nonatomic, assign)  UIEdgeInsets imageMargin;        // 图片与文字之间的间距

@property (nonatomic, assign) TLImageAlignment imageAlignment;  // 图片相对于文字的排版样式

@end
