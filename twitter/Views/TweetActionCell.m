//
//  TweetActionCell.m
//  twitter
//
//  Created by Veronica Zheng on 6/22/14.
//  Copyright (c) 2014 Veronica Zheng. All rights reserved.
//

#import "TweetActionCell.h"

@implementation TweetActionCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setRetweeted:(BOOL)retweeted {
    if (retweeted) {
        _retweetView.image = [UIImage imageNamed:@"retweet_on"];
    } else {
        _retweetView.image = [UIImage imageNamed:@"retweet"];
    }
}

- (void)setFavorited:(BOOL)favorited {
    if (favorited) {
        _favoriteView.image = [UIImage imageNamed:@"favorite_on"];
    } else {
        _favoriteView.image = [UIImage imageNamed:@"favorite"];
    }
}

@end
