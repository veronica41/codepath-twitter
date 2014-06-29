//
//  TTTweetViewViewController.m
//  twitter
//
//  Created by Veronica Zheng on 6/22/14.
//  Copyright (c) 2014 Veronica Zheng. All rights reserved.
//

#import "TweetViewController.h"
#import "ComposeViewController.h"
#import "TwitterClient.h"

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

@property (nonatomic) BOOL retweeted;
@property (nonatomic) BOOL favorited;

@end


@implementation TweetViewController

- (id)initWithTweet:(Tweet *)tweet andProfileImage:(UIImage *)profileImage {
    self = [super init];
    if (self) {
         _tweet = tweet;
        _profileImage = profileImage;
        _retweeted = _tweet.retweeted;
        _favorited = _tweet.favorited;
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
   // _userNameLabel.text = _tweet.author.name;
   // _userScreenNameLabel.text = _tweet.author.screenNameString;
   // _tweetLabel.text = _tweet.tweetString;
    _dateLabel.text = _tweet.createdAt.description;
}

- (void)setupCountRow {
    _retweetCountLabel.text = [NSString stringWithFormat:@"%ld", _tweet.retweetCount];
    _favoritesCountLabel.text = [NSString stringWithFormat:@"%ld", _tweet.favoriteCount];
}

- (void)setupActionRow {
    [self setRetweetedState:_tweet.retweeted];
    [self setFavoriteState:_tweet.favorited];

    UITapGestureRecognizer *replyTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(replyButtonHandler:)];
    replyTap.numberOfTapsRequired = 1;
    _replyImageView.userInteractionEnabled = YES;
    [_replyImageView addGestureRecognizer:replyTap];

    UITapGestureRecognizer *retweetTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(retweetButtonHandler:)];
    retweetTap.numberOfTapsRequired = 1;
    _retweetImageView.userInteractionEnabled = YES;
    [_retweetImageView addGestureRecognizer:retweetTap];

    UITapGestureRecognizer *favoriteTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(favoriteButtonHandler:)];
    favoriteTap.numberOfTapsRequired = 1;
    _favoriteImageView.userInteractionEnabled = YES;
    [_favoriteImageView addGestureRecognizer:favoriteTap];

}

- (void)viewWillDisappear:(BOOL)animated {
    // post the change to twitter
    [self updateRetweeted];
    [self updateFavorited];
}

- (void)updateRetweeted {
    if (!_tweet.retweeted && _retweeted) {
        [[TwitterClient instance] retweetWithStatusID:_tweet.tweetID success:^(AFHTTPRequestOperation *operation, id response) {
            //NSLog(@"Response : %@", response);
            _tweet.retweetID = response[@"id_str"];
            NSLog(@"response: %@", _tweet.retweetID);
            _tweet.retweeted = _retweeted;
            [self.delegate retweetedStateChanged:_tweet];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"retweet error: %@", error);
        }];
    }
    if (_tweet.retweeted && !_retweeted) {
        [[TwitterClient instance] destroyStatusWithStatusID:_tweet.retweetID success:^(AFHTTPRequestOperation *operation, id response) {
            NSLog(@"Response : %@", response);
            _tweet.retweeted = _retweeted;
            [self.delegate retweetedStateChanged:_tweet];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"retweet error: %@", error);
        }];
    }
}

- (void)updateFavorited {
    if (!_tweet.favorited && _favorited) {
        [[TwitterClient instance] createFavoriteWithStatusID:_tweet.tweetID success:^(AFHTTPRequestOperation *operation, id response) {
            _tweet.favorited = _favorited;
            [self.delegate favoritedStateChanged:_tweet];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"favorite error: %@", error);
        }];
    }
    if (_tweet.favorited && !_favorited) {
        [[TwitterClient instance] destroyFavoriteWithStatusID:_tweet.tweetID success:^(AFHTTPRequestOperation *operation, id response) {
            NSLog(@"Response : %@", response);
            _tweet.favorited = _favorited;
            [self.delegate favoritedStateChanged:_tweet];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"favorite error: %@", error);
        }];
    }
}

#pragma mark - button handlers

- (void)replyButtonHandler:(id)sender {
    ComposeViewController * controller = [[ComposeViewController alloc] initWithTweetType:TweetTypeReply Tweet:_tweet];
    UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:controller];
    [self presentViewController:nvc animated:YES completion:nil];
}

- (void)retweetButtonHandler:(id)sender {
    _retweeted = !_retweeted;
    [self setRetweetedState:_retweeted];
    if (_retweeted) {
        _tweet.retweetCount += 1;
        _retweetCountLabel.text = [NSString stringWithFormat:@"%ld", _tweet.retweetCount];
    } else {
        _tweet.retweetCount -= 1;
        _retweetCountLabel.text = [NSString stringWithFormat:@"%ld", _tweet.retweetCount];
    }
}

- (void)favoriteButtonHandler:(id)sender {
    _favorited = !_favorited;
    [self setFavoriteState:_favorited];
    if (_favorited) {
        _tweet.favoriteCount += 1;
        _favoritesCountLabel.text = [NSString stringWithFormat:@"%ld", _tweet.favoriteCount];
    } else {
        _tweet.favoriteCount -= 1;
        _favoritesCountLabel.text = [NSString stringWithFormat:@"%ld", _tweet.favoriteCount];
    }
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
