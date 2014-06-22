//
//  TTSignInViewController.m
//  twitter
//
//  Created by Veronica Zheng on 6/21/14.
//  Copyright (c) 2014 Veronica Zheng. All rights reserved.
//

#import "TTSignInViewController.h"
#import "TTTwitterClient.h"
#import "TTUser.h"

#define CALLBACK_URL @"tweeeetttter:/authorized"

@interface TTSignInViewController ()

@property (weak, nonatomic) IBOutlet UIButton *signinButton;
- (IBAction)signinButtonHandler:(id)sender;

@end

@implementation TTSignInViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)signinButtonHandler:(id)sender {
    [[TTTwitterClient instance] authorizeWithCallbackUrl:[NSURL URLWithString:CALLBACK_URL] success:^(AFOAuth1Token *accessToken, id responseObject) {
        [[TTTwitterClient instance] currentUserWithSuccess:^(AFHTTPRequestOperation *operation, id response) {
            NSError *error = nil;
            TTUser *user = [[TTUser alloc] initWithDictionary:response[@"response"] error:&error];
            if (user) {
                [TTUser setCurrentUser:user];
                NSLog(@"current user: %@", user);
            } else {
                [self showError:error];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [self showError:error];
        }];
    } failure:^(NSError *error) {
        [self showError:error];
    }];
}

- (void)showError:(NSError *)error {
    NSLog(@"Sign in Error: %@", error);
    [[[UIAlertView alloc] initWithTitle:@"Sign in Error"
                                message:@"Cannot sign in with Twitter, please try again later!"
                               delegate:nil
                      cancelButtonTitle:@"OK"
                      otherButtonTitles:nil] show];

}
@end
