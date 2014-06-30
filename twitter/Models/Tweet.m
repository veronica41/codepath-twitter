//
//  TTTweet.m
//  twitter
//
//  Created by Veronica Zheng on 6/22/14.
//  Copyright (c) 2014 Veronica Zheng. All rights reserved.
//

#import "Tweet.h"

@implementation Tweet

+ (NSArray *)tweetsFromJSONArray:(NSArray *)array {
    NSError *error;
    NSArray *tweets = [MTLJSONAdapter modelsOfClass:Tweet.class fromJSONArray:array error:&error];
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
             @"createdAt" : @"created_at",
             @"retweetedTweet" : @"retweeted_status",
             };
}

+ (NSValueTransformer *)userJSONTransformer {
    return [NSValueTransformer mtl_JSONDictionaryTransformerWithModelClass:User.class];
}

+ (NSDateFormatter *)dateFormatter {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    dateFormatter.dateFormat = @"EEE MMM dd HH:mm:ss ZZZZ yyyy'";
    return dateFormatter;
}

+ (NSValueTransformer *)createdAtJSONTransformer {
    return [MTLValueTransformer reversibleTransformerWithForwardBlock:^(NSString *str) {
        return [self.dateFormatter dateFromString:str];
    } reverseBlock:^(NSDate *date) {
        return [self.dateFormatter stringFromDate:date];
    }];
}

+ (NSValueTransformer *)retweetedTweetJSONTransformer {
    return [NSValueTransformer mtl_JSONDictionaryTransformerWithModelClass:Tweet.class];
}

- (NSString *)retweetedLabelString {
    if (self.retweetedTweet) {
        return [NSString stringWithFormat:@"%@ retweeted", self.user.name];
    }
    return nil;
}


@end
