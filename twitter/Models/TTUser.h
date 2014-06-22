//
//  TTUser.h
//  twitter
//
//  Created by Veronica Zheng on 6/21/14.
//  Copyright (c) 2014 Veronica Zheng. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const UserDidLoginNotification;
extern NSString *const UserDidLogoutNotification;

@interface TTUser : NSObject

+ (TTUser *)currentUser;
+ (void)setCurrentUser:(TTUser *)currentUser;

@end
