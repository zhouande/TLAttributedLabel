//
//  TLAttributedLabelConst.h
//  TLAttributedLabel
//
//  Created by andezhou on 15/8/18.
//  Copyright (c) 2015年 andezhou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface TLAttributedLabelConst : NSObject

// 日志输出
#ifdef DEBUG
#define TLLog(...) NSLog(__VA_ARGS__)
#else
#define TLLog(...)
#endif

// 本地图片标记
UIKIT_EXTERN NSString *const TLPictureBeginFlag;
UIKIT_EXTERN NSString *const TLPictureEndFlag;

// 替换url的链接文字和图片
UIKIT_EXTERN NSString *const TLReplaceURLTitle;
UIKIT_EXTERN NSString *const TLReplaceURLImageName;

// 获取网络图片的替换图片
UIKIT_EXTERN NSString *const TLPlaceholderImageName;

/*++++++++++++++++++++JSON网络获取布局++++++++++++++++++++++++++*/
// 展示类型（文字，图片，链接）
UIKIT_EXTERN NSString *const TLJSONTypeKey;
UIKIT_EXTERN NSString *const TLJSONTypeValueTXT;
UIKIT_EXTERN NSString *const TLJSONTypeValueIMG;
UIKIT_EXTERN NSString *const TLJSONTypeValueLINK;

// 文本内容
UIKIT_EXTERN NSString *const TLJSONContentKey;
// 文字字体大小
UIKIT_EXTERN NSString *const TLJSONFontSizeKey;

// 行间距
UIKIT_EXTERN NSString *const TLJSONLineSpacingKey;
// 段间距
UIKIT_EXTERN NSString *const TLJSONParagraphSpacingKey;
// 文本对齐方式
UIKIT_EXTERN NSString *const TLJSONTextAlignmentKey;
UIKIT_EXTERN NSString *const TLJSONTextAlignmentRightValue;
UIKIT_EXTERN NSString *const TLJSONTextAlignmentCenterValue;
UIKIT_EXTERN NSString *const TLJSONTextAlignmentJustifiedValue;
UIKIT_EXTERN NSString *const TLJSONTextAlignmentNaturalValue;

// URL链接
UIKIT_EXTERN NSString *const TLJSONURLKey;

// 图片名称
UIKIT_EXTERN NSString *const TLJSONImageNameKey;

// 图片宽高
UIKIT_EXTERN NSString *const TLJSONImageWidthKey;
UIKIT_EXTERN NSString *const TLJSONImageHeightKey;

// 文字颜色
UIKIT_EXTERN NSString *const TLJSONColorKey;

/*++++++++++++++++++++JSON网络获取布局++++++++++++++++++++++++++*/

@end
