//
//  UIColor+Twitter.m
//  twitter
//
//  Created by Veronica Zheng on 6/21/14.
//  Copyright (c) 2014 Veronica Zheng. All rights reserved.
//

#import "UIColor+Twitter.h"

@implementation UIColor (Twitter)

+ (UIColor *)twitterBlueColor {
    static UIColor *twitterBlueColor = nil;
    if (!twitterBlueColor){
        twitterBlueColor = [UIColor colorWithRed:85/255.0 green:172/255.0 blue:238/255.0 alpha:1.0];
    }
    return twitterBlueColor;
}

+ (UIColor *)twitterLightestGreyColor {
    static UIColor *twitterLightestGreyColor = nil;
    if (!twitterLightestGreyColor){
        twitterLightestGreyColor = [UIColor colorWithRed:245/255.0 green:248/255.0 blue:250/255.0 alpha:1.0];
    }
    return twitterLightestGreyColor;
}

+ (UIColor *)twitterGreyColor {
    static UIColor *twitterGreyColor = nil;
    if (!twitterGreyColor){
        twitterGreyColor = [UIColor colorWithRed:204/255.0 green:214/255.0 blue:221/255.0 alpha:1.0];
    }
    return twitterGreyColor;
}


@end
