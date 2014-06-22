//
//  TTUser.m
//  twitter
//
//  Created by Veronica Zheng on 6/21/14.
//  Copyright (c) 2014 Veronica Zheng. All rights reserved.
//

#import "TTUser.h"
#import "TTTwitterClient.h"

NSString * const UserDidLoginNotification = @"UserDidLoginNotification";
NSString * const UserDidLogoutNotification = @"UserDidLogoutNotification";
NSString * const currentUserKey = @"CurrentUserKey";

@implementation TTUser

static TTUser *_currentUser;

+ (TTUser *)currentUser {
    if (!_currentUser) {
        NSData *data = [[NSUserDefaults standardUserDefaults] dataForKey:currentUserKey];
        if (data) {
            NSError * error = nil;
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
            if (error) {
                NSLog(@"Error parsing JSON: %@", error);
            } else {
                error = nil;
                _currentUser = [[TTUser alloc] initWithDictionary:dict error:&error];
                if (error) {
                     NSLog(@"Error: %@", error);
                }
            }
        }
    }
    return _currentUser;
}

+ (void)setCurrentUser:(TTUser *)currentUser {
    if (currentUser) {
        NSError * error = nil;
        NSData *data = [NSJSONSerialization dataWithJSONObject:[MTLJSONAdapter JSONDictionaryFromModel:currentUser] options:NSJSONWritingPrettyPrinted error:&error];
        if (error) {
             NSLog(@"Error parsing JSON: %@", error);
        } else {
            [[NSUserDefaults standardUserDefaults] setObject:data forKey:currentUserKey];
        }
    } else {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:currentUserKey];
        [TTTwitterClient instance].accessToken = nil;
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
    return @{@"name": @"name",
             @"screenName" : @"screen_name",
             @"profileImageUrl" : @"profile_image_url"
             };
}

+ (NSValueTransformer *)profileImageUrlSONTransformer {
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}


@end