//
//  TTTweet.m
//  twitter
//
//  Created by Veronica Zheng on 6/22/14.
//  Copyright (c) 2014 Veronica Zheng. All rights reserved.
//

#import "Tweet.h"
#import "NSDate+DateTools.h"

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
             @"retweeted" : @"retweeted",
             @"favorited" : @"favorited",
             @"user" : @"user",
             @"text" : @"text",
             @"retweetedStatusUser" : @"retweeted_status",
             @"retweetedStatusText" : @"retweeted_status",
             @"createdAt" : @"created_at"
             };
}

+ (NSValueTransformer *)userJSONTransformer {
    return [NSValueTransformer mtl_JSONDictionaryTransformerWithModelClass:User.class];
}

/*
 [@"retweeted_status"][@"user"]
 */
+ (NSValueTransformer *)retweetedStatusUserJSONTransformer {
    return [MTLValueTransformer transformerWithBlock:^(NSDictionary *retweetedStatus) {
        NSDictionary *userDict = retweetedStatus[@"user"];
        NSError *error = nil;
        User *user = [MTLJSONAdapter modelOfClass:User.class fromJSONDictionary:userDict error:&error];
        if (error) {
            NSLog(@"authorJSONTransformer Error: %@", error);
        }
        return user;
    }];
}

/*
 [@"retweeted_status"][@"text"]
 */
+ (NSValueTransformer *)retweetedStatusTextJSONTransformer {
    return [MTLValueTransformer transformerWithBlock:^(NSDictionary *retweetedStatus) {
        return retweetedStatus[@"text"];
    }];
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

- (id)init {
    self = [super init];
    if (self) {
        _tweetID = nil;
        _retweetCount = 0;
        _favoriteCount = 0;
        _retweeted = NO;
        _favorited = NO;
        _user = nil;
        _text = nil;
        _retweetedStatusUser = nil;
        _retweetedStatusText = nil;
        _createdAt = [NSDate date];
    }
    return self;
}

#pragma mark - API

- (NSString *)retweetedLabelString {
    if (_retweetedStatusUser) {
        return [NSString stringWithFormat:@"%@ retweeted", _user.name];
    }
    return nil;
}
- (User *)author {
    if (_retweetedStatusUser) {
        return _retweetedStatusUser;
    }
    return _user;
}

- (NSString *)tweetString {
    if (_retweetedStatusText) {
        return _retweetedStatusText;
    }
    return _text;
}

- (NSString *)timeAgoString {
    return [_createdAt shortTimeAgoSinceNow];
}

@end
