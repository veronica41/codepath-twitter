//
//  UserProfile.m
//  twitter
//
//  Created by Veronica Zheng on 6/29/14.
//  Copyright (c) 2014 Veronica Zheng. All rights reserved.
//

#import "UserProfile.h"

@implementation UserProfile

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{@"screenName" : @"screen_name",
             @"profileImageUrl" : @"profile_image_url",
             @"profileUseBackgroundImage" : @"profile_use_background_image",
             @"profileBackgroundImageUrl" : @"profile_background_image_url",
             @"followersCount" : @"followers_count",
             @"followingCount" : @"friends_count",
             @"statusesCount" : @"statuses_count"
             };
}

+ (NSValueTransformer *)profileImageUrlJSONTransformer {
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

+ (NSValueTransformer *)profileBackgroundImageUrlJSONTransformer {
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

@end
