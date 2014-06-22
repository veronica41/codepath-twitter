//
//  TTTweet.m
//  twitter
//
//  Created by Veronica Zheng on 6/22/14.
//  Copyright (c) 2014 Veronica Zheng. All rights reserved.
//

#import "TTTweet.h"

@implementation TTTweet

+ (NSArray *)tweetsFromJSONArray:(NSArray *)array {
    NSError *error;
    NSArray *tweets = [MTLJSONAdapter modelsOfClass:TTTweet.class fromJSONArray:array error:&error];
    if (error) {
        NSLog(@"Error converting JSON array: %@", error);
        return nil;
    }
    return tweets;
}

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{@"tweetID" : @"id_str",
             @"retweetCount" : @"retweet_count",
             @"favoriteCount" : @"favorite_count",
             @"user" : @"user",
             @"text" : @"text",
             @"createdAt" : @"created_at",
             @"retweetedStatus" : @"retweeted_status"
             };
}



@end
