//
//  UserProfileViewController.h
//  twitter
//
//  Created by Veronica Zheng on 6/29/14.
//  Copyright (c) 2014 Veronica Zheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

@interface UserProfileViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) User *user;

@end
