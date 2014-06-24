//
//  TTTweetViewViewController.m
//  twitter
//
//  Created by Veronica Zheng on 6/22/14.
//  Copyright (c) 2014 Veronica Zheng. All rights reserved.
//

#import "TweetViewController.h"

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
@property (weak, nonatomic) IBOutlet UIImageView *retweetImageView;
@property (weak, nonatomic) IBOutlet UIImageView *favoriteImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *profileImageTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *userNameTopConstraint;

@end


@implementation TweetViewController

- (id)initWithTweet:(Tweet *)tweet andProfileImage:(UIImage *)profileImage {
    self = [super init];
    if (self) {
        _tweet = tweet;
        _profileImage = profileImage;
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
    if (_tweet.retweetedLabelString) {
        [_retweetedMarkImage setHidden:NO];
        [_retweetedLabel setHidden:NO];
        _retweetedLabel.text = _tweet.retweetedLabelString;
        _profileImageTopConstraint.constant = 42;
        _userNameTopConstraint.constant = 48;
    } else {
        [_retweetedMarkImage setHidden:YES];
        [_retweetedLabel setHidden:YES];
        _profileImageTopConstraint.constant = 12;
        _userNameTopConstraint.constant = 18;
    }

    _profileImageView.image = _profileImage;
    _userNameLabel.text = _tweet.author.name;
    _userScreenNameLabel.text = _tweet.author.screenNameString;
    _tweetLabel.text = _tweet.tweetString;
    _dateLabel.text = _tweet.createdAt.description;
}

- (void)setupCountRow {
    _retweetCountLabel.text = [NSString stringWithFormat:@"%ld", _tweet.retweetCount];
    _favoritesCountLabel.text = [NSString stringWithFormat:@"%ld", _tweet.favoriteCount];
}

- (void)setupActionRow {
    [self setRetweetedState:_tweet.retweeted];
    [self setFavoriteState:_tweet.favorited];
}


#pragma mark - button handlers

- (void)replyButtonHandler:(id)sender {
    // TODO
}

- (void)setRetweetedState:(BOOL)retweeted {
    if (retweeted) {
        _retweetImageView.image = [UIImage imageNamed:@"retweet_on"];
    } else {
        _retweetImageView.image = [UIImage imageNamed:@"retweet"];
    }
}

- (void)setFavoriteState:(BOOL)favorited {
    if (favorited) {
        _favoriteImageView.image = [UIImage imageNamed:@"favorite_on"];
    } else {
        _favoriteImageView.image = [UIImage imageNamed:@"favorite"];
    }
}


@end
