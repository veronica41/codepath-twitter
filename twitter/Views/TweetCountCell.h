//
//  TweetStaticCell.h
//  twitter
//
//  Created by Veronica Zheng on 6/22/14.
//  Copyright (c) 2014 Veronica Zheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TweetCountCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *retweetCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *favoriteCountLabel;

- (void)setRetweetCount:(NSInteger)retweetCount andFavoriteCount:(NSInteger)favoriteCount;

@end
