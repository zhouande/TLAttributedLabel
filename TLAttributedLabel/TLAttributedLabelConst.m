//
//  TLAttributedLabelConst.m
//  TLAttributedLabel
//
//  Created by andezhou on 15/8/18.
//  Copyright (c) 2015年 andezhou. All rights reserved.
//

#import "TLAttributedLabelConst.h"

@implementation TLAttributedLabelConst

// 本地图片标记
NSString *const TLPictureBeginFlag = @"[/";
NSString *const TLPictureEndFlag   = @"]";

// 替换url的链接文字和图片
NSString *const TLReplaceURLTitle     = @"网页链接";
NSString *const TLReplaceURLImageName = @"timeline_card_small_web";

// 获取网络图片的替换图片
NSString *const TLPlaceholderImageName = nil;

/*++++++++++++++++++++JSON网络获取布局++++++++++++++++++++++++++*/
// 展示类型（文字，图片，链接）
NSString *const TLJSONTypeKey = @"type";
NSString *const TLJSONTypeValueTXT = @"txt";
NSString *const TLJSONTypeValueIMG = @"img";
NSString *const TLJSONTypeValueLINK = @"link";

// 文本内容
NSString *const TLJSONContentKey = @"content";
// 文字字体大小
NSString *const TLJSONFontSizeKey = @"size";
// 文字颜色
NSString *const TLJSONColorKey = @"color";

// 行间距
NSString *const TLJSONLineSpacingKey = @"lineSpace";
// 段间距
NSString *const TLJSONParagraphSpacingKey = @"paragraphSpacing";
// 文本对齐方式
NSString *const TLJSONTextAlignmentKey = @"alignment";
NSString *const TLJSONTextAlignmentRightValue = @"right";
NSString *const TLJSONTextAlignmentCenterValue = @"center";
NSString *const TLJSONTextAlignmentJustifiedValue = @"justified";
NSString *const TLJSONTextAlignmentNaturalValue = @"natural";

// URL链接
NSString *const TLJSONURLKey = @"url";

// 图片名称
NSString *const TLJSONImageNameKey = @"name";

// 图片宽高
NSString *const TLJSONImageWidthKey = @"width";
NSString *const TLJSONImageHeightKey = @"height";

/*++++++++++++++++++++JSON网络获取布局++++++++++++++++++++++++++*/

@end
