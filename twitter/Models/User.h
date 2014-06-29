//
//  TTUser.h
//  twitter
//
//  Created by Veronica Zheng on 6/21/14.
//  Copyright (c) 2014 Veronica Zheng. All rights reserved.
//

#import "Mantle.h"

extern NSString *const UserDidLoginNotification;
extern NSString *const UserDidLogoutNotification;

@interface User : MTLModel <MTLJSONSerializing>

+ (User *)currentUser;
+ (void)setCurrentUser:(User *)currentUser;

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *screenName;
@property (nonatomic, copy) NSURL* profileImageUrl;

- (NSString *)screenNameString;

@end
