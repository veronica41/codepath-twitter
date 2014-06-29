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
@property (weak, nonatomic) IBOutlet UIImageView *retweetImageView;
@property (weak, nonatomic) IBOutlet UIImageView *favoriteImageView;

@end


@implementation TimelineTableViewCell

- (id)init {
    self = [super init];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
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

    [self.profileImage setImageWithURL:originalTweet.user.profileImageUrl];
    self.userNameLabel.text = originalTweet.user.name;
    self.userScreenNameLabel.text = originalTweet.user.screenNameString;
    self.dateLabel.text = originalTweet.createdAt.shortTimeAgoSinceNow;
    self.tweetLabel.text = originalTweet.text;

    [self setRetweeted:tweet.retweeted];
    [self setFavorited:tweet.favorited];
}

- (void)setRetweeted:(BOOL)retweeted {
    self.tweet.retweeted = retweeted;
    if (retweeted) {
        self.retweetImageView.image = [UIImage imageNamed:@"retweet_on"];
    } else {
        self.retweetImageView.image = [UIImage imageNamed:@"retweet"];
    }
}

- (void)setFavorited:(BOOL)favorited {
    self.tweet.favorited = favorited;
    if (favorited) {
        self.favoriteImageView.image = [UIImage imageNamed:@"favorite_on"];
    } else {
        self.favoriteImageView.image = [UIImage imageNamed:@"favorite"];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.tweetLabel.preferredMaxLayoutWidth = self.frame.size.width - 76;
    [super layoutSubviews];
}

@end