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

NSInteger const kTweetCharacterLimit = 140;

@interface ComposeViewController ()

@property (nonatomic) TweetType tweetType;
@property (nonatomic, strong) UILabel *characterCountLabel;
@property (nonatomic, strong) UIBarButtonItem * tweetButton;

@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *userScreenNameLabel;
@property (weak, nonatomic) IBOutlet UITextView *tweetTextView;

@end


@implementation ComposeViewController

- (id)initWithTweetType:(TweetType)type {
    self = [super init];
    if (self) {
        self.tweetType = type;
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
    self.tweetButton = [[UIBarButtonItem alloc] initWithTitle:@"Tweet" style:UIBarButtonItemStylePlain target:self action:@selector(tweetButtonHandler:)];
    self.navigationItem.leftBarButtonItem = cancelButton;
    self.navigationItem.rightBarButtonItem = self.tweetButton;

    self.edgesForExtendedLayout = UIRectEdgeNone;

    self.characterCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(228, 15, 60, 14)];
    self.characterCountLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.characterCountLabel.text = [@(kTweetCharacterLimit) stringValue];
    self.characterCountLabel.backgroundColor = [UIColor clearColor];
    self.characterCountLabel.font = [UIFont fontWithName:@"Helvitica" size:14.0];
    self.characterCountLabel.textColor = [UIColor twitterGreyColor];
    [self.navigationController.navigationBar addSubview:self.characterCountLabel];

    User *user = [User currentUser];
    [self.profileImageView setImageWithURL:user.profileImageUrl];
    self.userNameLabel.text = user.name;
    self.userScreenNameLabel.text = user.screenName;
    if (self.tweetType == TweetTypeReply) {
        self.tweetTextView.text = user.screenNameString;
    }
    self.tweetTextView.delegate = self;
    [self.tweetTextView becomeFirstResponder];
}

#pragma mark - UITextViewDelegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    NSInteger remain= kTweetCharacterLimit-_tweetTextView.text.length;
    if (remain >= 0) {
        self.characterCountLabel.text = [@(remain) stringValue];
        self.tweetButton.enabled = YES;
        return YES;
    }
    self.tweetButton.enabled = NO;
    return NO;
}

#pragma mark - button handlers

- (void)cancelButtonHandler:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)tweetButtonHandler:(id)sender {
    NSString * status = self.tweetTextView.text;
    NSString * replyTo = nil;
    if (self.tweetType == TweetTypeReply) replyTo = self.replyToTweet.tweetID;
    [[TwitterClient instance] postNewStatus:status withReplyToID:replyTo success:^(AFHTTPRequestOperation *operation, id response) {
        NSLog(@"post status response : %@", response);
        NSError *error;
        Tweet *tweet = [MTLJSONAdapter modelOfClass:[Tweet class] fromJSONDictionary:response error:&error];
        if (tweet) {
            [self.delegate didPostTweet:tweet];
        } else {
            NSLog(@"Error: %@", error);
        }
        [self dismissViewControllerAnimated:YES completion:nil];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self showError:error];
    }];
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