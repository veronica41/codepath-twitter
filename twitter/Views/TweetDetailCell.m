//
//  TweetDetailCell.m
//  twitter
//
//  Created by Veronica Zheng on 6/22/14.
//  Copyright (c) 2014 Veronica Zheng. All rights reserved.
//

#import "TweetDetailCell.h"
#import "UIImageView+AFNetworking.h"

@implementation TweetDetailCell {
    Tweet *_tweet;
}

- (void)setTweet:(Tweet *)tweet andProfileImage:(UIImage *)image {
    _tweet = tweet;
    if (tweet.retweetedLabelString) {
        _retweetLabel.text = tweet.retweetedLabelString;
    } else {
        [self removeRetweetedViews];
    }
    _profileImageView.image = image;
    _userNameLabel.text = tweet.author.name;
    _userScreenNameLabel.text = tweet.author.screenNameString;
    _tweetLabel.text = tweet.tweetString;
    _dateLabel.text = tweet.createdAt.description;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _tweetLabel.preferredMaxLayoutWidth = self.frame.size.width - 32;
    [super layoutSubviews];
}

- (void)removeRetweetedViews {
    [_retweetedMarkImage removeFromSuperview];
    [_retweetLabel removeFromSuperview];
    /*
    if (_tweeterLabelVerticalConstraint) {
        [self.contentView removeConstraint:_tweeterLabelVerticalConstraint];
    }
    NSDictionary *views = NSDictionaryOfVariableBindings(_profileImage, _tweetLabel, _userNameLabel, _replyImageView);
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(12)-[_profileImage]" options:0 metrics:nil views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(35)-[_tweetLabel]" options:0 metrics:nil views:views]];
    */
    [_tweetLabel layoutSubviews];
}

@end
