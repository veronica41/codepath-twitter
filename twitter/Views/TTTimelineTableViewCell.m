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

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setTweet:(TTTweet *)tweet {
    _tweet = tweet;
   // [_profileImage setImageWithURL:tweet.user.profileImageUrl];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end