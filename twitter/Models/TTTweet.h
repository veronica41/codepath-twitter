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
@property (nonatomic, copy) TTUser *user;
@property (nonatomic, copy) NSString *text;
@property (nonatomic, copy) NSDate *createdAt;
@property (nonatomic, copy) TTTweet *retweetedStatus;

@end
