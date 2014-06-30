//
//  TTTimelineTableViewCell.h
//  twitter
//
//  Created by Veronica Zheng on 6/22/14.
//  Copyright (c) 2014 Veronica Zheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"
#import "RetweetImageView.h"
#import "FavoriteImageView.h"
#import "TweetViewController.h"

@interface TimelineTableViewCell : UITableViewCell <RetweetImageViewDelegate, FavoriteImageViewDelegate, TweetViewControllerDelegate>

@property (nonatomic, strong) Tweet *tweet;

@end
