//
//  SlidingViewController.m
//  twitter
//
//  Created by Veronica Zheng on 6/30/14.
//  Copyright (c) 2014 Veronica Zheng. All rights reserved.
//

#import "SlidingViewController.h"

@interface SlidingViewController ()

@end

@implementation SlidingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithMainViewController:(UIViewController *)mainViewController {
    self = [self initWithNibName:nil bundle:nil];
    if (self) {
        self.mainViewController = mainViewController;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (!self.mainViewController) [NSException raise:@"Missing mainViewController" format:@"set mainViewController before loading DrawerViewController"];
    self.mainViewController.view.frame = self.view.bounds;
    [self.view addSubview:self.mainViewController.view];
}

#pragma mark - Properties

- (void)setMainViewController:(UIViewController *)mainViewController {
    UIViewController *oldMainViewController = _mainViewController;
    _mainViewController = mainViewController;

    [oldMainViewController willMoveToParentViewController:nil];
    [oldMainViewController.view removeFromSuperview];
    [oldMainViewController removeFromParentViewController];

    if (mainViewController) {
        [self addChildViewController:mainViewController];
        [mainViewController didMoveToParentViewController:self];
        if ([self isViewLoaded]) {
            [self.view addSubview:mainViewController.view];
        }
    }
}

- (void)setDrawerViewController:(UIViewController *)drawerViewController {
    UIViewController *oldDrawerViewController = _drawerViewController;
    _drawerViewController = drawerViewController;

    [oldDrawerViewController willMoveToParentViewController:nil];
    [oldDrawerViewController.view removeFromSuperview];
    [oldDrawerViewController removeFromParentViewController];

    if (drawerViewController) {
        [self addChildViewController:drawerViewController];
        [drawerViewController didMoveToParentViewController:self];
    }
}

@end
