//
//  TTTweetViewViewController.m
//  twitter
//
//  Created by Veronica Zheng on 6/22/14.
//  Copyright (c) 2014 Veronica Zheng. All rights reserved.
//

#import "TweetViewController.h"
#import "ComposeViewController.h"
#import "UserProfileViewController.h"
#import "TwitterClient.h"
#import "UIImageView+AFNetworking.h"
#import "NSDate+DateTools.h"

@interface TweetViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *retweetedMarkImage;
@property (weak, nonatomic) IBOutlet UILabel *retweetedLabel;
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *userScreenNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *tweetLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *retweetCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *favoritesCountLabel;
@property (weak, nonatomic) IBOutlet UIImageView *replyImageView;
@property (weak, nonatomic) IBOutlet RetweetImageView *retweetImageView;
@property (weak, nonatomic) IBOutlet FavoriteImageView *favoriteImageView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *profileImageTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *userNameTopConstraint;

@property (nonatomic, strong) User *author;

@end


@implementation TweetViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // setup the navigation bar
    UIBarButtonItem *homeButton = [[UIBarButtonItem alloc] initWithTitle:@"Home" style:UIBarButtonItemStylePlain target:nil action:nil];
    UIBarButtonItem *replyButton = [[UIBarButtonItem alloc] initWithTitle:@"Reply" style:UIBarButtonItemStylePlain target:self action:@selector(replyButtonHandler:)];
    self.navigationItem.title = @"Tweet";
    self.navigationItem.backBarButtonItem = homeButton;
    self.navigationItem.rightBarButtonItem = replyButton;

    [self setupDetailsRow];
    [self setupCountRow];
    [self setupActionRow];
}

- (void)setupDetailsRow {
    Tweet *originalTweet;
    if (self.tweet.retweetedTweet) {
        originalTweet = self.tweet.retweetedTweet;
        [self.retweetedMarkImage setHidden:NO];
        [self.retweetedLabel setHidden:NO];
        self.retweetedLabel.text = self.tweet.retweetedLabelString;
        self.profileImageTopConstraint.constant = 42;
        self.userNameTopConstraint.constant = 48;
    } else {
        originalTweet = self.tweet;
        [self.retweetedMarkImage setHidden:YES];
        [self.retweetedLabel setHidden:YES];
        self.profileImageTopConstraint.constant = 12;
        self.userNameTopConstraint.constant = 18;
    }
    self.author = originalTweet.user;

    [self.profileImageView setImageWithURL:originalTweet.user.profileImageUrl];
    UITapGestureRecognizer *profileImageTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onProfileImage:)];
    profileImageTap.numberOfTapsRequired = 1;
    self.profileImageView.userInteractionEnabled = YES;
    [self.profileImageView addGestureRecognizer:profileImageTap];

    self.userNameLabel.text = originalTweet.user.name;
    self.userScreenNameLabel.text = originalTweet.user.screenNameString;
    self.tweetLabel.text = originalTweet.text;
    self.dateLabel.text = [originalTweet.createdAt formattedDateWithFormat:@"M/dd/yy, hh:mm a"];
}

- (void)setupCountRow {
    self.retweetCountLabel.text = [@(self.tweet.retweetCount) stringValue];
    self.favoritesCountLabel.text = [@(self.tweet.favoriteCount) stringValue];
}

- (void)setupActionRow {
    [self.retweetImageView setTweet:self.tweet];
    self.retweetImageView.delegate = self;
    [self.favoriteImageView setTweet:self.tweet];
    self.favoriteImageView.delegate = self;

    UITapGestureRecognizer *replyTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(replyButtonHandler:)];
    replyTap.numberOfTapsRequired = 1;
    self.replyImageView.userInteractionEnabled = YES;
    [self.replyImageView addGestureRecognizer:replyTap];
}

- (void)viewWillDisappear:(BOOL)animated {
    // post the change to twitter
    __weak TweetViewController *weakSelf = self;
    [self.retweetImageView postRetweetedWithCompletionHandler:^(Tweet *tweet, NSError *error) {
        if (tweet) {
            weakSelf.tweet = tweet;
            [weakSelf.delegate retweetedStateDidChangeForTweet:tweet];
        }
    }];

    [self.favoriteImageView postFavoritedWithCompletionHandler:^(Tweet *tweet, NSError *error) {
        if (tweet) {
            weakSelf.tweet = tweet;
            [weakSelf.delegate favoritedStateDidChangeForTweet:tweet];
        }
    }];
}

#pragma mark - RetweetImageViewDelegate

- (void)retweetedStateChanged:(Tweet *)tweet {
    self.tweet = tweet;
    self.retweetCountLabel.text = [@(tweet.retweetCount) stringValue];
}

#pragma mark - FavoriteImageViewDelegate

- (void)favoritedStateChanged:(Tweet *)tweet {
    self.tweet = tweet;
    self.favoritesCountLabel.text = [@(tweet.favoriteCount) stringValue];
}

#pragma mark - button handlers

- (void)replyButtonHandler:(id)sender {
    ComposeViewController * controller = [[ComposeViewController alloc] initWithTweetType:TweetTypeReply];
    controller.replyToTweet = self.tweet;
    UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:controller];
    [self presentViewController:nvc animated:YES completion:nil];
}

- (void)onProfileImage:(UIGestureRecognizer *)gestureRecognizer {
    UserProfileViewController *profileController = [[UserProfileViewController alloc] init];
    profileController.user = self.author;
    [self.navigationController pushViewController:profileController animated:YES];
    [self.navigationController.view clipsToBounds];
}

@end
