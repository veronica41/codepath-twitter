//
//  FavoriteImageView.h
//  twitter
//
//  Created by Veronica Zheng on 6/29/14.
//  Copyright (c) 2014 Veronica Zheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"

@protocol FavoriteImageViewDelegate <NSObject>

- (void)favoritedStateChanged:(Tweet *)tweet; // favorite button is clicked

@end


@interface FavoriteImageView : UIImageView

@property (nonatomic, weak) id<FavoriteImageViewDelegate> delegate;

- (void)setTweet:(Tweet *)tweet;
- (void)postFavoritedWithCompletionHandler:(void(^)(Tweet *tweet, NSError *error))completionHandler;

@end
