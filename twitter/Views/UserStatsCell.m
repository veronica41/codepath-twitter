//
//  UserStatsCell.m
//  twitter
//
//  Created by Veronica Zheng on 7/1/14.
//  Copyright (c) 2014 Veronica Zheng. All rights reserved.
//
#import "UserStatsCell.h"

@interface UserStatsCell ()

@property (weak, nonatomic) IBOutlet UILabel *tweetsCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *followersCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *followingCountLabel;

@end


@implementation UserStatsCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setUserProfile:(UserProfile *)userProfile {
    self.tweetsCountLabel.text = [@(userProfile.statusesCount) stringValue];
    self.followersCountLabel.text = [@(userProfile.followersCount) stringValue];
    self.followingCountLabel.text = [@(userProfile.followingCount) stringValue];
}

@end
