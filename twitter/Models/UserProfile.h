//
//  UserProfile.h
//  twitter
//
//  Created by Veronica Zheng on 6/29/14.
//  Copyright (c) 2014 Veronica Zheng. All rights reserved.
//

#import "Mantle.h"

@interface UserProfile : MTLModel <MTLJSONSerializing>

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *screenName;
@property (nonatomic, copy) NSURL* profileImageUrl;
@property (nonatomic) BOOL profileUseBackgroundImage;
@property (nonatomic, copy) NSURL* profileBackgroundImageUrl;
@property (nonatomic) NSInteger followersCount;
@property (nonatomic) NSInteger followingCount;
@property (nonatomic) NSInteger statusesCount;

@end
