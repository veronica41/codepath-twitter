//
//  SlidingViewController.m
//  twitter
//
//  Created by Veronica Zheng on 6/30/14.
//  Copyright (c) 2014 Veronica Zheng. All rights reserved.
//

#import "SlidingViewController.h"
#import "UIView+Utilities.h"

static CGFloat kDrawerViewWidth = 285.0;

@interface SlidingViewController ()

@property (nonatomic) BOOL isDrawerShowing;
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
        self.isDrawerShowing = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.view addSubview:self.mainViewController.view];
    self.mainViewController.view.frame = self.view.bounds;
    UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    self.mainViewController.view.userInteractionEnabled = YES;
    [self.mainViewController.view addGestureRecognizer:panRecognizer];
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


- (void)handlePan:(UIPanGestureRecognizer *)sender {
    CGPoint translation = [sender translationInView:self.view];
    [sender setTranslation:CGPointMake(0, 0) inView:self.view];

}

- (void)toggleDrawerView {
    if (self.isDrawerShowing) {
        [self dismissDrawerView];
    } else {
        [self showDrawerView];
    }
}

- (void)showDrawerView {
    if (!self.drawerViewController) return;
    [self disableViewsForDragging];

    CGRect frame = self.view.bounds;
    frame.size.width = kDrawerViewWidth;
    self.drawerViewController.view.frame = frame;
    [self.view insertSubview:self.drawerViewController.view belowSubview:self.mainViewController.view];
    
    [UIView animateWithDuration:0.4 delay:0.0 usingSpringWithDamping:1.0 initialSpringVelocity:0.0 options:0 animations:^{
        self.mainViewController.view.left = kDrawerViewWidth;
    } completion:^(BOOL completed) {
        [self enableViewsForDragging];
        self.isDrawerShowing = YES;
    }];

}

- (void)dismissDrawerView {
    if (!self.drawerViewController) return;
    [self disableViewsForDragging];
 
    [UIView animateWithDuration:0.4 delay:0.0 usingSpringWithDamping:1.0 initialSpringVelocity:0.0 options:0 animations:^{
        self.mainViewController.view.left = 0.0;
    } completion:^(BOOL completed) {
        [self.drawerViewController.view removeFromSuperview];
        [self enableViewsForDragging];
        self.isDrawerShowing = NO;
    }];
}

- (void)enableViewsForDragging {
    self.mainViewController.view.userInteractionEnabled = YES;
    self.drawerViewController.view.userInteractionEnabled = YES;
}

- (void)disableViewsForDragging {
    self.mainViewController.view.userInteractionEnabled = NO;
    self.drawerViewController.view.userInteractionEnabled = NO;
}


@end
