//
//  TTUser.m
//  twitter
//
//  Created by Veronica Zheng on 6/21/14.
//  Copyright (c) 2014 Veronica Zheng. All rights reserved.
//

#import "User.h"
#import "TwitterClient.h"

NSString * const UserDidLoginNotification = @"UserDidLoginNotification";
NSString * const UserDidLogoutNotification = @"UserDidLogoutNotification";
NSString * const kCurrentUserKey = @"CurrentUserKey";

@implementation User

static User *_currentUser = nil;

+ (User *)currentUser {
    if (!_currentUser) {
        NSData *data = [[NSUserDefaults standardUserDefaults] dataForKey:kCurrentUserKey];
        if (data) {
            _currentUser = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        }
    }
    return _currentUser;
}

+ (void)setCurrentUser:(User *)currentUser {
    if (currentUser) {
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:currentUser];
        [[NSUserDefaults standardUserDefaults] setObject:data forKey:kCurrentUserKey];
    } else {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:kCurrentUserKey];
        [TwitterClient instance].accessToken = nil;
    }
    [[NSUserDefaults standardUserDefaults] synchronize];

    if (!_currentUser && currentUser) {
        _currentUser = currentUser;
        [[NSNotificationCenter defaultCenter] postNotificationName:UserDidLoginNotification object:nil];
    } else  if (_currentUser && !currentUser) {
        _currentUser = currentUser;
        [[NSNotificationCenter defaultCenter] postNotificationName:UserDidLogoutNotification object:nil];
    }
    
}

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{@"screenName" : @"screen_name",
             @"profileImageUrl" : @"profile_image_url"
             };
}

+ (NSValueTransformer *)profileImageUrlJSONTransformer {
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

- (NSString *)screenNameString {
    return [NSString stringWithFormat:@"@%@", _screenName];
}

@end