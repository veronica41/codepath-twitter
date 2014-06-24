//
//  TTTimelineTableViewCell.m
//  twitter
//
//  Created by Veronica Zheng on 6/22/14.
//  Copyright (c) 2014 Veronica Zheng. All rights reserved.
//

#import "TimelineTableViewCell.h"
#import "UIImageView+AFNetworking.h"

@interface TimelineTableViewCell ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *profileImageTopConstraint;
@end


@implementation TimelineTableViewCell

- (void)setTweet:(Tweet *)tweet {
    _tweet = tweet;
    if (tweet.retweetedLabelString) {
        [_retweetedMarkImageView setHidden:NO];
        [_retweetLabel setHidden:NO];
        _retweetLabel.text = tweet.retweetedLabelString;
        _profileImageTopConstraint.constant = 35;
    } else {
        [_retweetedMarkImageView setHidden:YES];
        [_retweetLabel setHidden:YES];
        _profileImageTopConstraint.constant = 12;
    }

    [_profileImage setImageWithURL:[NSURL URLWithString:tweet.author.profileImageUrl]];
    _userNameLabel.text = tweet.author.name;
    _userScreenNameLabel.text = tweet.author.screenNameString;
    _dateLabel.text = tweet.timeAgoString;
    _tweetLabel.text = tweet.tweetString;
    if (tweet.retweeted) {
        _retweetImageView.image = [UIImage imageNamed:@"retweet_on"];
    }
    if (tweet.favorited) {
        _favoriteImageView.image = [UIImage imageNamed:@"favorite_on"];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _tweetLabel.preferredMaxLayoutWidth = self.frame.size.width - 76;
    [super layoutSubviews];
}

@end