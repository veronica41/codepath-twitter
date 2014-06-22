//
//  TTTwitterClient.h
//  twitter
//
//  Created by Veronica Zheng on 6/21/14.
//  Copyright (c) 2014 Veronica Zheng. All rights reserved.
//

#import "AFOAuth1Client.h"

@interface TTTwitterClient : AFOAuth1Client

+ (TTTwitterClient *)instance;
- (void)authorizeWithCallbackUrl:(NSURL *)callbackUrl success:(void (^) (AFOAuth1Token *accessToken, id responseObject))success failure:(void (^) (NSError *error))failure;

@end
