//
//  TLAppDelegate+Helper.m
//  TLAttributedLabel
//
//  Created by andezhou on 15/8/17.
//  Copyright (c) 2015年 andezhou. All rights reserved.
//

#import "TLAppDelegate+Helper.h"

@implementation TLAppDelegate (Helper)

- (UIViewController *)topMostController {
    UIViewController *topController = [self.window rootViewController];
    
    while ([topController presentedViewController])	topController = [topController presentedViewController];

    return topController;
}

- (UIViewController *)currentViewController {
    UIViewController *currentViewController = [self topMostController];
    
    while ([currentViewController isKindOfClass:[UINavigationController class]] && [(UINavigationController*)currentViewController topViewController])
        
        currentViewController = [(UINavigationController*)currentViewController topViewController];
    
    return currentViewController;
}

@end
