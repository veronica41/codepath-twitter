//
//  TweetActionCell.h
//  twitter
//
//  Created by Veronica Zheng on 6/22/14.
//  Copyright (c) 2014 Veronica Zheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TweetActionCell : UITableViewCell

@property (nonatomic) BOOL retweeted;
@property (nonatomic) BOOL favorited;

@property (weak, nonatomic) IBOutlet UIImageView *replyView;
@property (weak, nonatomic) IBOutlet UIImageView *retweetView;
@property (weak, nonatomic) IBOutlet UIImageView *favoriteView;

@end
