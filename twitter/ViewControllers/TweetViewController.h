//
//  TTTweetViewViewController.h
//  twitter
//
//  Created by Veronica Zheng on 6/22/14.
//  Copyright (c) 2014 Veronica Zheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"
#import "RetweetImageView.h"
#import "FavoriteImageView.h"

@protocol TweetViewControllerDelegate <NSObject>

- (void)retweetedStateDidChangeForTweet:(Tweet *)tweet;
- (void)favoritedStateDidChangeForTweet:(Tweet *)tweet;

@end


@interface TweetViewController : UIViewController <RetweetImageViewDelegate, FavoriteImageViewDelegate>

@property (nonatomic, weak) id<TweetViewControllerDelegate> delegate;
@property (nonatomic, strong) Tweet *tweet;

- (id)initWithTweet:(Tweet *)tweet;

@end