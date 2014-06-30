//
//  RetweetImageView.m
//  twitter
//
//  Created by Veronica Zheng on 6/29/14.
//  Copyright (c) 2014 Veronica Zheng. All rights reserved.
//

#import "RetweetImageView.h"
#import "TwitterClient.h"

@interface RetweetImageView ()

@property (nonatomic, strong) Tweet *tweet;
@property (nonatomic) BOOL oldRetweeted;

- (void)setRetweeted:(BOOL)retweeted;

@end


@implementation RetweetImageView

- (void)setTweet:(Tweet *)tweet {
    _tweet = tweet;
    self.oldRetweeted = tweet.retweeted;
    [self setRetweeted:tweet.retweeted];

    // do not allow retweet the tweet the user created
    if (![self.tweet.user.screenName isEqualToString:[User currentUser].screenName]) {
        UITapGestureRecognizer *retweetTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onRetweet:)];
        retweetTap.numberOfTapsRequired = 1;
        self.userInteractionEnabled = YES;
        [self addGestureRecognizer:retweetTap];
    }
}

- (void)setRetweeted:(BOOL)retweeted {
    self.tweet.retweeted = retweeted;
    if (retweeted) {
        self.image = [UIImage imageNamed:@"retweet_on"];
    } else {
        self.image = [UIImage imageNamed:@"retweet"];
    }
}

- (void)postRetweetedWithCompletionHandler:(void(^)(Tweet *, NSError *))completionHandler {
    __weak RetweetImageView *weakSelf = self;
    if (!self.oldRetweeted && self.tweet.retweeted) {
        [[TwitterClient instance] retweetWithStatusID:self.tweet.tweetID success:^(AFHTTPRequestOperation *operation, id response) {
            weakSelf.tweet.retweetID = response[@"id_str"];
            completionHandler(weakSelf.tweet, nil);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"retweet error: %@", error);
            completionHandler(nil, error);
        }];
    }

    if (self.oldRetweeted && !self.tweet.retweeted) {
        [[TwitterClient instance] destroyStatusWithStatusID:self.tweet.retweetID success:^(AFHTTPRequestOperation *operation, id response) {
            completionHandler(weakSelf.tweet, nil);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"retweet error: %@", error);
            completionHandler(nil, error);
        }];
    }
}

- (void)onRetweet:(id)sender {
    [self setRetweeted:!self.tweet.retweeted];
    if (self.tweet.retweeted) {
        self.tweet.retweetCount += 1;
    } else {
        self.tweet.retweetCount -= 1;
    }
    [self.delegate retweetedStateChanged:self.tweet];
}

@end
