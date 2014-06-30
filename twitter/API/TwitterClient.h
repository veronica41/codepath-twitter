//
//  TTTwitterClient.h
//  twitter
//
//  Created by Veronica Zheng on 6/21/14.
//  Copyright (c) 2014 Veronica Zheng. All rights reserved.
//

#import "AFOAuth1Client.h"

typedef enum {
    TimeLineTypeHome = 0,
    TimelineTypeMentions = 1
} TimelineType;

@interface TwitterClient : AFOAuth1Client

+ (TwitterClient *)instance;

- (void)authorizeWithCallbackUrl:(NSURL *)callbackUrl
                         success:(void (^) (AFOAuth1Token *accessToken, id responseObject))success
                         failure:(void (^) (NSError *error))failure;
- (void)currentUserWithSuccess:(void (^)(AFHTTPRequestOperation *operation, id response))success
                       failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
- (void)getUserProfileWithScreenName:(NSString *)screenName
                      success:(void (^)(AFHTTPRequestOperation *operation, id response))success
                      failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

- (void)TimelineWithType:(TimelineType)type
                   maxId:(NSString *)maxId
                 success:(void (^)(AFHTTPRequestOperation *operation, id response))success
                 failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
- (void)UserTimelineWithScreenName:(NSString *)screenName
                           success:(void (^)(AFHTTPRequestOperation *operation, id response))success
                           failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

- (void)getStatusWithID:(NSString *)statusID
                success:(void (^)(AFHTTPRequestOperation *operation, id response))success
                failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
- (void)postNewStatus:(NSString *)status
        withReplyToID:(NSString *)reply_to_id
              success:(void (^)(AFHTTPRequestOperation *operation, id response))success
              failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

- (void)retweetWithStatusID:(NSString *)statusID
                    success:(void (^)(AFHTTPRequestOperation *operation, id response))success
                    failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
- (void)destroyStatusWithStatusID:(NSString *)statusID
                          success:(void (^)(AFHTTPRequestOperation *operation, id response))success
                          failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

- (void)createFavoriteWithStatusID:(NSString *)statusID
                           success:(void (^)(AFHTTPRequestOperation *operation, id response))success
                     failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
- (void)destroyFavoriteWithStatusID:(NSString *)statusID
                            success:(void (^)(AFHTTPRequestOperation *operation, id response))success
                           failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;


@end
