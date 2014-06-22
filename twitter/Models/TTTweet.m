//
//  TTTweet.m
//  twitter
//
//  Created by Veronica Zheng on 6/22/14.
//  Copyright (c) 2014 Veronica Zheng. All rights reserved.
//

#import "TTTweet.h"
#import "NSDate+DateTools.h"

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
             @"retweeted" : @"retweeted",
             @"favorited" : @"favorited",
             @"author" : @"retweeted_status",
             @"retweetUser" : @"user",
             @"text" : @"text",
             @"originalText" : @"retweeted_status",
             @"createdAt" : @"created_at"
             };
}

+ (NSValueTransformer *)authorJSONTransformer {
    return [MTLValueTransformer transformerWithBlock:^(NSDictionary *retweetedStatus) {
        NSDictionary *userDict = retweetedStatus[@"user"];
        NSError *error = nil;
        TTUser *user = [MTLJSONAdapter modelOfClass:TTUser.class fromJSONDictionary:userDict error:&error];
        if (error) {
            NSLog(@"authorJSONTransformer Error: %@", error);
        }
        return user;
    }];
}

/*
 The text in the original tweet that was retweeted
 */
+ (NSValueTransformer *)originalTextJSONTransformer {
    return [MTLValueTransformer transformerWithBlock:^(NSDictionary *retweetedStatus) {
        return retweetedStatus[@"text"];
    }];
}

- (NSString *)timeAgoString {
    return _createdAt.shortTimeAgoSinceNow;
}

- (NSString *)retweetedLabelString {
    if (_retweetUser) {
        return [NSString stringWithFormat:@"%@ retweeted", _retweetUser.name];
        
    }
    return nil;
}

@end
