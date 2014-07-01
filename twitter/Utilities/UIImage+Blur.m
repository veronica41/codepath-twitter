//
//  UIImage+Blur.m
//  twitter
//
//  Created by Veronica Zheng on 7/1/14.
//  Copyright (c) 2014 Veronica Zheng. All rights reserved.
//

#import "UIImage+Blur.h"

@implementation UIImage (Blur)

+ (UIImage *)BlurImage:(UIImage *)imageToBlur withRadius:(CGFloat)blurRadius {
    CIImage *originalImage = [CIImage imageWithCGImage: imageToBlur.CGImage];
    CIFilter *filter = [CIFilter filterWithName: @"CIGaussianBlur" keysAndValues:kCIInputImageKey, originalImage, @"inputRadius", @(blurRadius), nil];
    CIImage *outputImage = filter.outputImage;
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef outImage = [context createCGImage:outputImage fromRect:[outputImage extent]];
    return [UIImage imageWithCGImage: outImage];
}

@end
