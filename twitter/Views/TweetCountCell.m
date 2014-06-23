//
//  TweetStaticCell.m
//  twitter
//
//  Created by Veronica Zheng on 6/22/14.
//  Copyright (c) 2014 Veronica Zheng. All rights reserved.
//

#import "TweetCountCell.h"

@implementation TweetCountCell

- (void)awakeFromNib
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setRetweetCount:(NSInteger)retweetCount andFavoriteCount:(NSInteger)favoriteCount {
    _retweetCountLabel.text = [NSString stringWithFormat:@"%ld", retweetCount];
    _favoriteCountLabel.text = [NSString stringWithFormat:@"%ld", favoriteCount];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
