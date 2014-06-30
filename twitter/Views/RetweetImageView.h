//
//  RetweetImageView.h
//  twitter
//
//  Created by Veronica Zheng on 6/29/14.
//  Copyright (c) 2014 Veronica Zheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"

@protocol RetweetImageViewDelegate <NSObject>

- (void)retweetedStateChanged:(Tweet *)tweet; // retweet button is clicked

@end


@interface RetweetImageView : UIImageView

@property (nonatomic, weak) id<RetweetImageViewDelegate> delegate;

- (void)setTweet:(Tweet *)tweet;
- (void)postRetweetedWithCompletionHandler:(void(^)(Tweet *tweet, NSError *error))completionHandler;

@end
