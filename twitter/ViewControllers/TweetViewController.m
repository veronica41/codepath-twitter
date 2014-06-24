//
//  TTTweetViewViewController.m
//  twitter
//
//  Created by Veronica Zheng on 6/22/14.
//  Copyright (c) 2014 Veronica Zheng. All rights reserved.
//

#import "TweetViewController.h"
#import "TweetDetailCell.h"
#import "TweetCountCell.h"
#import "TweetActionCell.h"

static NSString * tweetDetailCellIdentifier = @"TweetDetailCell";
static NSString * tweetCountCellIdentifier = @"TweetCountCell";
static NSString * tweetActionCellIdentifier = @"TweetActionCell";

@interface TweetViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) TweetDetailCell *tweetDetailCell;
@property (nonatomic, strong) TweetCountCell *tweetCountCell;
@property (nonatomic, strong) TweetActionCell *tweetActionCell;

@end


@implementation TweetViewController

- (id)initWithTweet:(Tweet *)tweet andProfileImage:(UIImage *)profileImage {
    self = [super init];
    if (self) {
        _tweet = tweet;
        _profileImage = profileImage;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // setup the navigation bar
    UIBarButtonItem *homeButton = [[UIBarButtonItem alloc] initWithTitle:@"Home" style:UIBarButtonItemStylePlain target:self action:@selector(homeButtonHandler:)];
    UIBarButtonItem *replyButton = [[UIBarButtonItem alloc] initWithTitle:@"Reply" style:UIBarButtonItemStylePlain target:self action:@selector(replyButtonHandler:)];
    self.navigationItem.title = @"Tweet";
    self.navigationItem.backBarButtonItem = homeButton;
    self.navigationItem.rightBarButtonItem = replyButton;
    
    // setup the table view
    _tableView.dataSource = self;
    _tableView.delegate = self;

    UINib *tweetDetailCellNib = [UINib nibWithNibName:tweetDetailCellIdentifier bundle:nil];
    [_tableView registerNib:tweetDetailCellNib forCellReuseIdentifier:tweetDetailCellIdentifier];
    _tweetDetailCell = [_tableView dequeueReusableCellWithIdentifier:tweetDetailCellIdentifier];
    [_tweetDetailCell setTweet:_tweet andProfileImage:_profileImage];

    UINib *tweetCountCellNib = [UINib nibWithNibName:tweetCountCellIdentifier bundle:nil];
    [_tableView registerNib:tweetCountCellNib forCellReuseIdentifier:tweetCountCellIdentifier];
    _tweetCountCell = [_tableView dequeueReusableCellWithIdentifier:tweetCountCellIdentifier];
    [_tweetCountCell setRetweetCount:_tweet.retweetCount andFavoriteCount:_tweet.favoriteCount];

    UINib *tweetActionCellNib = [UINib nibWithNibName:tweetActionCellIdentifier bundle:nil];
    [_tableView registerNib:tweetActionCellNib forCellReuseIdentifier:tweetActionCellIdentifier];
    _tweetActionCell = [_tableView dequeueReusableCellWithIdentifier:tweetActionCellIdentifier];
    [_tweetActionCell setRetweeted:_tweet.retweeted];
    [_tweetActionCell setFavorited:_tweet.favorited];
}

#pragma mark - UITableViewDataSource

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:
            return _tweetDetailCell;
        case 1:
            return _tweetCountCell;
        case 2:
            return _tweetActionCell;
        case 3:
            return [[UITableViewCell alloc] init];
    }
    return nil;
}

#pragma mark - UITableViewDelegate


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        CGFloat height = _tweetDetailCell.tweetLabel.frame.size.height;
        return height+124;
    }
    if (indexPath.row > 0 && indexPath.row < 3 )return 50;
    if (indexPath.row == 3) {
        CGFloat height = _tableView.frame.size.height - _tableView.contentSize.height;
        return height;
    }
    return 0;
}


#pragma mark - button handlers

- (void)homeButtonHandler:(id)sender {
    
}

- (void)replyButtonHandler:(id)sender {
    
}

@end
