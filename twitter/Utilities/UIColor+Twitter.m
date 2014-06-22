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


@end
