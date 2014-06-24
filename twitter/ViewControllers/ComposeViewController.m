//
//  ComposeViewController.m
//  twitter
//
//  Created by Veronica Zheng on 6/24/14.
//  Copyright (c) 2014 Veronica Zheng. All rights reserved.
//

#import "ComposeViewController.h"
#import "User.h"
#import "UIColor+Twitter.h"
#import "UIImageView+AFNetworking.h"
#import "TwitterClient.h"

#define TWEET_LIMIT 140

@interface ComposeViewController ()

@property (nonatomic, strong) UILabel *characterCountLabel;
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *userScreenNameLabel;
@property (weak, nonatomic) IBOutlet UITextView *tweetTextView;

@end


@implementation ComposeViewController

- (id)initWithTweetType:(TweetType)type Tweet:(Tweet *)tweet {
    self = [super init];
    if (self) {
        _tweetType = type;
        _tweet = tweet;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // setup the navigation bar
    [self.navigationController.navigationBar setBarTintColor:[UIColor twitterLightestGreyColor]];
    [self.navigationController.navigationBar setTintColor:[UIColor twitterBlueColor]];

    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancelButtonHandler:)];
    UIBarButtonItem *tweetButton = [[UIBarButtonItem alloc] initWithTitle:@"Tweet" style:UIBarButtonItemStylePlain target:self action:@selector(tweetButtonHandler:)];
    self.navigationItem.leftBarButtonItem = cancelButton;
    self.navigationItem.rightBarButtonItem = tweetButton;

    self.edgesForExtendedLayout = UIRectEdgeNone;

    _characterCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(228, 15, 60, 14)];
    _characterCountLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _characterCountLabel.text = [NSString stringWithFormat:@"%d", TWEET_LIMIT];
    _characterCountLabel.backgroundColor = [UIColor clearColor];
    _characterCountLabel.font = [UIFont fontWithName:@"Helvitica" size:14.0];
    _characterCountLabel.textColor = [UIColor twitterGreyColor];
    [self.navigationController.navigationBar addSubview:_characterCountLabel];

    User *user = [User currentUser];
    [_profileImageView setImageWithURL:[NSURL URLWithString:user.profileImageUrl]];
    _userNameLabel.text = user.name;
    _userScreenNameLabel.text = user.screenName;
    _tweetTextView.delegate = self;
    [_tweetTextView becomeFirstResponder];
}

#pragma mark - UITextViewDelegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    NSInteger remain= TWEET_LIMIT-_tweetTextView.text.length;
    if (remain >= 0) {
        _characterCountLabel.text = [NSString stringWithFormat:@"%ld", remain];
        return YES;
    }
    return NO;
}

#pragma mark - button handlers

- (void)cancelButtonHandler:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)tweetButtonHandler:(id)sender {
    NSString * status = _tweetTextView.text;
    [[TwitterClient instance] postNewStatus:status success:^(AFHTTPRequestOperation *operation, id response) {
        NSLog(@"post status response : %@", response);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self showError:error];
    }];
    [self.delegate createNewTweetWithStatus:status];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)showError:(NSError *)error {
    NSLog(@"Post status error: %@", error);
    [[[UIAlertView alloc] initWithTitle:@"Post status error"
                            message:@"Cannot post status now, please try again later!"
                           delegate:nil
                  cancelButtonTitle:@"OK"
                  otherButtonTitles:nil] show];
}

@end