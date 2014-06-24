//
//  TTTweetViewViewController.h
//  twitter
//
//  Created by Veronica Zheng on 6/22/14.
//  Copyright (c) 2014 Veronica Zheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"

@protocol TweetViewControllerDelegate <NSObject>

- (void)retweetedStateChanged:(Tweet *)tweet;
- (void)favoritedStateChanged:(Tweet *)tweet;

@end


@interface TweetViewController : UIViewController

@property (nonatomic, weak) id<TweetViewControllerDelegate> delegate;
@property (nonatomic, strong) Tweet *tweet;
@property (nonatomic, strong) UIImage *profileImage;

- (id)initWithTweet:(Tweet *)tweet andProfileImage:(UIImage *)profileImage;

@end