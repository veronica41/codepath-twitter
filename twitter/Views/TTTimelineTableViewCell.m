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
    _profileImage.image = nil;
    self.userInteractionEnabled = NO;
}

- (void)setTweet:(TTTweet *)tweet {
    _tweet = tweet;
    if (tweet.retweetUser) {
        _retweetLabel.text = tweet.retweetedLabelString;
    }
    [_profileImage setImageWithURL:[NSURL URLWithString:tweet.retweetUser.profileImageUrl]];
    _userNameLabel.text = tweet.author.name;
    _userScreenNameLabel.text = tweet.author.screenNameString;
    _dateLabel.text = tweet.timeAgoString;
    _tweetLabel.text = tweet.originalText ? tweet.originalText : tweet.text;
    if (tweet.retweeted) {
        _retweetImageView.image = [UIImage imageNamed:@"retweet_on"];
    }
    if (tweet.favorited) {
        _favoriteImageView.image = [UIImage imageNamed:@"favorite_on"];
    }
}

@end