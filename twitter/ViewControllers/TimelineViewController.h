//
//  TTTimelineViewController.h
//  twitter
//
//  Created by Veronica Zheng on 6/22/14.
//  Copyright (c) 2014 Veronica Zheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ComposeViewController.h"
#import "TimelineTableViewCell.h"
#import "TweetViewController.h"
#import "TwitterClient.h"

@interface TimelineViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, ComposeViewControllerDelegate, TimelineTableViewCellDelegate>

@property (nonatomic) TimelineType type;

@end
