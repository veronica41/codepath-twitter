//
//  TTTimelineTableViewCell.h
//  twitter
//
//  Created by Veronica Zheng on 6/22/14.
//  Copyright (c) 2014 Veronica Zheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"

@interface TimelineTableViewCell : UITableViewCell

@property (nonatomic, strong) Tweet *tweet;

- (void)setRetweeted:(BOOL)retweeted;
- (void)setFavorited:(BOOL)favorited;

@end
