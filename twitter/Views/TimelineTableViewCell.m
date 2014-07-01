//
//  TTTimelineTableViewCell.m
//  twitter
//
//  Created by Veronica Zheng on 6/22/14.
//  Copyright (c) 2014 Veronica Zheng. All rights reserved.
//

#import "TimelineTableViewCell.h"
#import "UIImageView+AFNetworking.h"
#import "NSDate+DateTools.h"

NSInteger const kProfileImageTopConstraintWithRetweet = 35;
NSInteger const kProfileImageTopConstraintWithoutRetweet = 12;

@interface TimelineTableViewCell ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *profileImageTopConstraint;

@property (weak, nonatomic) IBOutlet UIImageView *retweetedMarkImageView;
@property (weak, nonatomic) IBOutlet UILabel *retweetLabel;
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *userScreenNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *tweetLabel;
@property (weak, nonatomic) IBOutlet UIImageView *replyImageView;
@property (weak, nonatomic) IBOutlet RetweetImageView *retweetImageView;
@property (weak, nonatomic) IBOutlet FavoriteImageView *favoriteImageView;

@property (nonatomic, strong) User *author;

@end


@implementation TimelineTableViewCell

- (void)awakeFromNib {
    UITapGestureRecognizer *profileImageTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onProfileImage:)];
    profileImageTap.numberOfTapsRequired = 1;
    self.profileImage.userInteractionEnabled = YES;
    [self.profileImage addGestureRecognizer:profileImageTap];
}

- (void)setTweet:(Tweet *)tweet {
    _tweet = tweet;

    self.profileImage.image = nil;

    Tweet *originalTweet;
    if (tweet.retweetedTweet) {
        originalTweet = tweet.retweetedTweet;
        [self.retweetedMarkImageView setHidden:NO];
        [self.retweetLabel setHidden:NO];
        self.retweetLabel.text = tweet.retweetedLabelString;
        self.profileImageTopConstraint.constant = kProfileImageTopConstraintWithRetweet;
    } else {
        originalTweet = tweet;
        [self.retweetedMarkImageView setHidden:YES];
        [self.retweetLabel setHidden:YES];
        self.profileImageTopConstraint.constant = kProfileImageTopConstraintWithoutRetweet;
    }

    self.author = originalTweet.user;
    [self.profileImage setImageWithURL:originalTweet.user.profileImageUrl];
    self.userNameLabel.text = originalTweet.user.name;
    self.userScreenNameLabel.text = originalTweet.user.screenNameString;
    self.dateLabel.text = originalTweet.createdAt.shortTimeAgoSinceNow;
    self.tweetLabel.text = originalTweet.text;

    [self.retweetImageView setTweet:tweet];
    self.retweetImageView.delegate = self;
    [self.favoriteImageView setTweet:tweet];
    self.favoriteImageView.delegate = self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.tweetLabel.preferredMaxLayoutWidth = self.frame.size.width - 76;
    [super layoutSubviews];
}

#pragma mark - RetweetImageViewDelegate

- (void)retweetedStateChanged:(Tweet *)tweet {
    __weak TimelineTableViewCell *weakSelf = self;
    [self.retweetImageView postRetweetedWithCompletionHandler:^(Tweet *tweet, NSError *error) {
        if (tweet) weakSelf.tweet = tweet;
    }];
}

#pragma mark - FavoriteImageViewDelegate

- (void)favoritedStateChanged:(Tweet *)tweet {
    __weak TimelineTableViewCell *weakSelf = self;
    [self.favoriteImageView postFavoritedWithCompletionHandler:^(Tweet *tweet, NSError *error) {
        if (tweet) weakSelf.tweet = tweet;
    }];
}

#pragma mark - TweetViewControllerDelegate

- (void)retweetedStateDidChangeForTweet:(Tweet *)tweet {
    [self.retweetImageView setTweet:tweet];
}

- (void)favoritedStateDidChangeForTweet:(Tweet *)tweet {
    [self.favoriteImageView setTweet:tweet];
}

- (void)onProfileImage:(UIGestureRecognizer *)gestureRecognizer {
    [self.delegate didTapProfileImageForUser:self.author];
}

@end