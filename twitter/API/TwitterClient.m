//
//  TTTwitterClient.m
//  twitter
//
//  Created by Veronica Zheng on 6/21/14.
//  Copyright (c) 2014 Veronica Zheng. All rights reserved.
//

#import "TwitterClient.h"
#import "AFNetworking.h"
#import "UICKeyChainStore.h"

#define TWITTER_BASE_URL [NSURL URLWithString:@"https://api.twitter.com/"]

#define TWITTER_CONSUMER_KEY @"o6umqnPD7QRXoHIDQzuUYXWdB"
#define TWITTER_CONSUMER_SECRET @"c1xm2B32T9uXH7QccNBgQpVeUOjvC6Akkrdz94oJMbHE51pSYx"

// used in keychain
static NSString * const serviceName =  @"tweeeetttter";
static NSString * const accessTokenKey = @"AccessTokenKey";

@implementation TwitterClient {
    UICKeyChainStore *_store;
}

+ (TwitterClient *)instance {
    static TwitterClient *instance;
    static dispatch_once_t once;

    dispatch_once(&once, ^{
        instance = [[TwitterClient alloc] initWithBaseURL:TWITTER_BASE_URL
                                                      key:TWITTER_CONSUMER_KEY
                                                   secret:TWITTER_CONSUMER_SECRET];
    });
    return instance;
}

- (id)initWithBaseURL:(NSURL *)url key:(NSString *)key secret:(NSString *)secret {
    self = [super initWithBaseURL:url key:key secret:secret];
    if (self) {
        [self registerHTTPOperationClass:[AFJSONRequestOperation class]];

        _store = [UICKeyChainStore keyChainStoreWithService:serviceName];
        NSData * data = [_store dataForKey:accessTokenKey];
        if (data) {
            self.accessToken = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        }
    }
    return self;
    
}

# pragma mark - Users API

- (void)authorizeWithCallbackUrl:(NSURL *)callbackUrl success:(void (^) (AFOAuth1Token *accessToken, id responseObject))success failure:(void (^) (NSError *error))failure {
    self.accessToken = nil;
    [super authorizeUsingOAuthWithRequestTokenPath:@"oauth/request_token"
                             userAuthorizationPath:@"oauth/authorize"
                                       callbackURL:callbackUrl
                                   accessTokenPath:@"oauth/access_token"
                                      accessMethod:@"POST"
                                             scope:nil
                                           success:success
                                           failure:failure];
}

- (void)currentUserWithSuccess:(void (^)(AFHTTPRequestOperation *operation, id response))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    [self getPath:@"1.1/account/verify_credentials.json"
       parameters:nil
          success:success
          failure:failure];
}

#pragma mark - Statuses API

- (void)getStatusWithID:(NSString *)statusID success:(void (^)(AFHTTPRequestOperation *operation, id response))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    NSString *url = [NSString stringWithFormat:@"1.1/statuses/show/%@.json", statusID];
    [self postPath:url parameters:nil success:success failure:failure];
}

- (void)homeTimelineWithCount:(int)count sinceId:(int)sinceId maxId:(int)maxId success:(void (^)(AFHTTPRequestOperation *operation, id response))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    if (count <= 0) count = 20;
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:@{@"count": @(count)}];
    if (sinceId > 0) {
        [params setObject:@(sinceId) forKey:@"since_id"];
    }
    if (maxId > 0) {
        [params setObject:@(maxId) forKey:@"max_id"];
    }
    [self getPath:@"1.1/statuses/home_timeline.json" parameters:params success:success failure:failure];
}

- (void)postNewStatus:(NSString *)status
        withReplyToID:(NSString *)reply_to_id
              success:(void (^)(AFHTTPRequestOperation *operation, id response))success
              failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    if (!status) return;
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:@{@"status": status}];
    if (reply_to_id) {
        [params setObject:reply_to_id forKey:@"in_reply_to_status_id"];
    }
    [self postPath:@"1.1/statuses/update.json" parameters:params success:success failure:failure];
}

- (void)retweetWithStatusID:(NSString *)statusID success:(void (^)(AFHTTPRequestOperation *operation, id response))success
                    failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    if (!statusID) return;
    NSString *url = [NSString stringWithFormat:@"1.1/statuses/retweet/%@.json", statusID];
    [self postPath:url parameters:nil success:success failure:failure];
}

- (void)destroyStatusWithStatusID:(NSString *)statusID success:(void (^)(AFHTTPRequestOperation *operation, id response))success
                          failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    if (!statusID) return;
    NSString *url = [NSString stringWithFormat:@"1.1/statuses/destroy/%@.json", statusID];
    [self postPath:url parameters:nil success:success failure:failure];
}

#pragma mark - Favorites APIs

- (void)createFavoriteWithStatusID:(NSString *)statusID success:(void (^)(AFHTTPRequestOperation *operation, id response))success
                           failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    if (!statusID) return;
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:@{@"id": statusID}];
    [self postPath:@"1.1/favorites/create.json" parameters:params success:success failure:failure];
}

- (void)destroyFavoriteWithStatusID:(NSString *)statusID success:(void (^)(AFHTTPRequestOperation *operation, id response))success
                           failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    if (!statusID) return;
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:@{@"id": statusID}];
    [self postPath:@"1.1/favorites/destroy.json" parameters:params success:success failure:failure];
}


#pragma mark - Override

- (void)setAccessToken:(AFOAuth1Token *)accessToken {
    [super setAccessToken:accessToken];
    if (accessToken) {
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:accessToken];
        [_store setData:data forKey:accessTokenKey];
    }
    [_store synchronize];
}

@end
