//
//  TLAttributedLabel.h
//  TLAttributedLabel
//
//  Created by andezhou on 15/7/29.
//  Copyright (c) 2015年 andezhou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreText/CoreText.h>
@class TLAttributedImage;
@class TLAttributedLink;

@interface TLAttributedLabelUtils : NSObject

/**
 *  @return 判断点击坐标是否在连接上， 如果点中反回链接的TLCoreTextLink， 如果没点中反回nil
 */
+ (TLAttributedLink *)touchLinkInView:(UIView *)view
                                links:(NSArray *)links
                                point:(CGPoint)point
                             frameRef:(CTFrameRef)frameRef;

@end
