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

@property (nonatomic, copy, readonly) NSString *name;
@property (nonatomic, copy, readonly) NSString *screenName;
@property (nonatomic, copy, readonly) NSURL* profileImageUrl;

+ (User *)currentUser;
+ (void)setCurrentUser:(User *)currentUser;
- (NSString *)screenNameString;

@end
