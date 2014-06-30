//
//  SlidingViewController.h
//  twitter
//
//  Created by Veronica Zheng on 6/30/14.
//  Copyright (c) 2014 Veronica Zheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SlidingViewController : UIViewController

/*
 the main view controller which will be showed initially
 */
@property (nonatomic, strong) UIViewController *mainViewController;

/*
 the drawer view controller which will be showed when the user drag it
 */
@property (nonatomic, strong) UIViewController *drawerViewController;

- (id)initWithMainViewController:(UIViewController *)mainViewController;

@end
