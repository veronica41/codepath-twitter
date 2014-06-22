//
//  TTTweet.h
//  twitter
//
//  Created by Veronica Zheng on 6/22/14.
//  Copyright (c) 2014 Veronica Zheng. All rights reserved.
//

#import "Mantle.h"
#import "TTUser.h"

@interface TTTweet : MTLModel <MTLJSONSerializing>

+ (NSArray *)tweetsFromJSONArray:(NSArray *)array;

@property (nonatomic, copy) NSString *tweetID;
@property (nonatomic) NSInteger retweetCount;
@property (nonatomic) NSInteger favoriteCount;
@property (nonatomic) BOOL retweeted;
@property (nonatomic) BOOL favorited;
@property (nonatomic, copy) TTUser *author;
@property (nonatomic, copy) TTUser *retweetUser;
@property (nonatomic, copy) NSString *text;
@property (nonatomic, copy) NSString *originalText;
@property (nonatomic, copy) NSDate *createdAt;

- (NSString *)timeAgoString;
- (NSString *)retweetedLabelString;

@end
