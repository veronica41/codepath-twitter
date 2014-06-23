//
//  TTTimelineTableViewCell.m
//  twitter
//
//  Created by Veronica Zheng on 6/22/14.
//  Copyright (c) 2014 Veronica Zheng. All rights reserved.
//

#import "TTTimelineTableViewCell.h"
#import "UIImageView+AFNetworking.h"

@implementation TTTimelineTableViewCell

- (void)awakeFromNib {
    _tweetLabel.text = nil;
}

- (void)setTweet:(TTTweet *)tweet {
    _tweet = tweet;
    if (tweet.retweetedLabelString) {
        _retweetLabel.text = tweet.retweetedLabelString;
    } else {
        _retweetLabel.text = @"abc";
        //_retweetedMarkImageView.image = nil;
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
    [self layoutIfNeeded];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _tweetLabel.preferredMaxLayoutWidth = self.frame.size.width - 76;
    [super layoutSubviews];
}

@end