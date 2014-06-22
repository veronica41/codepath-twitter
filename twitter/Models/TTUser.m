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
            if (!error) {
                //_currentUser = [[TTUser alloc] initWithDictionary:dict];
            }
        }
    }
    return _currentUser;
}

+ (void)setCurrentUser:(TTUser *)currentUser {
    
}



@end