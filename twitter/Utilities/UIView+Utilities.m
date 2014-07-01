//
//  UIView+Utilities.m
//  twitter
//
//  Created by Veronica Zheng on 7/1/14.
//  Copyright (c) 2014 Veronica Zheng. All rights reserved.
//

#import "UIView+Utilities.h"

@implementation UIView (Utilities)

- (CGFloat)left {
	return self.frame.origin.x;
}

- (void)setLeft:(CGFloat)x {
	CGRect frame = self.frame;
	frame.origin.x = x;
	self.frame = frame;
}

@end
