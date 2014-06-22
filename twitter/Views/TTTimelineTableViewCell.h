//
//  TTTimelineTableViewCell.h
//  twitter
//
//  Created by Veronica Zheng on 6/22/14.
//  Copyright (c) 2014 Veronica Zheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTTweet.h"

@interface TTTimelineTableViewCell : UITableViewCell

@property (nonatomic, strong) TTTweet *tweet;

@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UILabel *retweetLabel;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *userScreenNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *tweetLabel;
@property (weak, nonatomic) IBOutlet UIImageView *replyImageView;
@property (weak, nonatomic) IBOutlet UIImageView *retweetImageView;
@property (weak, nonatomic) IBOutlet UIImageView *favoriteImageView;

@end
