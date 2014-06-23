//
//  TTSignInViewController.m
//  twitter
//
//  Created by Veronica Zheng on 6/21/14.
//  Copyright (c) 2014 Veronica Zheng. All rights reserved.
//

#import "SignInViewController.h"
#import "TwitterClient.h"
#import "User.h"

#define CALLBACK_URL @"tweeeetttter:/authorized"

@interface SignInViewController ()

@property (weak, nonatomic) IBOutlet UIButton *signinButton;
- (IBAction)signinButtonHandler:(id)sender;

@end

@implementation SignInViewController

- (IBAction)signinButtonHandler:(id)sender {
    [[TwitterClient instance] authorizeWithCallbackUrl:[NSURL URLWithString:CALLBACK_URL] success:^(AFOAuth1Token *accessToken, id responseObject) {
        [[TwitterClient instance] currentUserWithSuccess:^(AFHTTPRequestOperation *operation, id response) {
            NSError *error = nil;
            User *user = [MTLJSONAdapter modelOfClass:User.class fromJSONDictionary:response error:&error];
            if (error) {
                [self showError:error];
            } else {
                [User setCurrentUser:user];
                NSLog(@"current user: %@", user);
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
