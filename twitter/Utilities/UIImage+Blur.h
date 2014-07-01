//
//  UIImage+Blur.h
//  twitter
//
//  Created by Veronica Zheng on 7/1/14.
//  Copyright (c) 2014 Veronica Zheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Blur)

+ (UIImage *)BlurImage:(UIImage *)imageToBlur withRadius:(CGFloat)blurRadius;

@end
