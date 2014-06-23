//
//  TTTimelineTableViewCell.m
//  twitter
//
//  Created by Veronica Zheng on 6/22/14.
//  Copyright (c) 2014 Veronica Zheng. All rights reserved.
//

#import "TTTimelineTableViewCell.h"
#import "UIImageView+AFNetworking.h"

@interface TTTimelineTableViewCell ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tweeterLabelVerticalConstraint;

@end


@implementation TTTimelineTableViewCell

- (void)awakeFromNib {
    _tweetLabel.text = nil;
}

- (void)setTweet:(TTTweet *)tweet {
    _tweet = tweet;
    if (tweet.retweetedLabelString) {
        _retweetLabel.text = tweet.retweetedLabelString;
    } else {
        [self removeRetweetedViews];
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

- (void)removeRetweetedViews {
    [_retweetedMarkImageView removeFromSuperview];
    [_retweetLabel removeFromSuperview];
    if (_tweeterLabelVerticalConstraint) {
        [self.contentView removeConstraint:_tweeterLabelVerticalConstraint];
    }
    NSDictionary *views = NSDictionaryOfVariableBindings(_profileImage, _tweetLabel);
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(12)-[_profileImage]" options:0 metrics:nil views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(34)-[_tweetLabel]" options:0 metrics:nil views:views]];
    [self updateConstraints];
}

@end