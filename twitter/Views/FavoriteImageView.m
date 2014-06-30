//
//  FavoriteImageView.m
//  twitter
//
//  Created by Veronica Zheng on 6/29/14.
//  Copyright (c) 2014 Veronica Zheng. All rights reserved.
//

#import "FavoriteImageView.h"
#import "TwitterClient.h"

@interface FavoriteImageView ()

@property (nonatomic, strong) Tweet *tweet;
@property (nonatomic) BOOL oldFavorited;

- (void)setFavorited:(BOOL)favorited;

@end


@implementation FavoriteImageView

- (void)awakeFromNib {
    UITapGestureRecognizer *favoriteTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onFavorite:)];
    favoriteTap.numberOfTapsRequired = 1;
    self.userInteractionEnabled = YES;
    [self addGestureRecognizer:favoriteTap];
}

- (void)setTweet:(Tweet *)tweet {
    _tweet = tweet;
    self.oldFavorited = tweet.favorited;
    [self setFavorited:tweet.favorited];
}

- (void)setFavorited:(BOOL)favorited {
    self.tweet.favorited = favorited;
    if (favorited) {
        self.image = [UIImage imageNamed:@"favorite_on"];
    } else {
        self.image = [UIImage imageNamed:@"favorite"];
    }
}

- (void)postFavoritedWithCompletionHandler:(void(^)(Tweet *tweet, NSError *error))completionHandler {
    __weak FavoriteImageView *weakSelf = self;
    if (!self.oldFavorited && self.tweet.favorited) {
        [[TwitterClient instance] createFavoriteWithStatusID:self.tweet.tweetID success:^(AFHTTPRequestOperation *operation, id response) {
            completionHandler(weakSelf.tweet, nil);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"favorite error: %@", error);
            completionHandler(nil, error);
        }];
    }
    if (self.oldFavorited && !self.tweet.favorited) {
        [[TwitterClient instance] destroyFavoriteWithStatusID:self.tweet.tweetID success:^(AFHTTPRequestOperation *operation, id response) {
            completionHandler(weakSelf.tweet, nil);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"favorite error: %@", error);
            completionHandler(nil, error);
        }];
    }
}

- (void)onFavorite:(id)sender {
    [self setFavorited:!self.tweet.favorited];
    if (self.tweet.favorited) {
        self.tweet.favoriteCount += 1;
    } else {
        self.tweet.favoriteCount -= 1;
    }
    [self.delegate favoritedStateChanged:self.tweet];
}

@end
