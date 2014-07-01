//
//  TTAppDelegate.m
//  twitter
//
//  Created by Veronica Zheng on 6/21/14.
//  Copyright (c) 2014 Veronica Zheng. All rights reserved.
//

#import "AppDelegate.h"
#import "TwitterClient.h"
#import "User.h"
#import "SignInViewController.h"
#import "TimelineViewController.h"
#import "SlidingViewController.h"
#import "DrawerViewController.h"
#import "UIColor+Twitter.h"

@implementation AppDelegate {
    SignInViewController * _signInViewController;
    SlidingViewController *_slidingViewController;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    // set styles for navigation bar
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    [[UINavigationBar appearance] setBarTintColor:[UIColor twitterBlueColor]];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
                                                           

    [self updateRootController];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateRootController) name:UserDidLoginNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateRootController) name:UserDidLogoutNotification object:nil];

    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    NSNotification *notification = [NSNotification notificationWithName:kAFApplicationLaunchedWithURLNotification
                                                                 object:nil
                                                               userInfo:[NSDictionary dictionaryWithObject:url forKey:kAFApplicationLaunchOptionsURLKey]];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - Private methods

- (void)updateRootController {
    if ([User currentUser]) {
        self.window.rootViewController = self.slidingViewController;
    } else {
        self.window.rootViewController = self.signInViewController;
    }
}

- (SignInViewController *)signInViewController {
    if (!_signInViewController) {
        _signInViewController = [[SignInViewController alloc] init];
    }
    return _signInViewController;
}

- (SlidingViewController *)slidingViewController {
    TimelineViewController * controller = [[TimelineViewController alloc] init];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:controller];
    navigationController.navigationBar.translucent = NO;
    _slidingViewController = [[SlidingViewController alloc] initWithMainViewController:navigationController];
    _slidingViewController.drawerViewController = [[DrawerViewController alloc] init];
    return _slidingViewController;
}

@end
