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
}

#pragma mark - UITableViewDataSource

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   // switch (indexPath.row) {
       // case 0: {
            return _tweetDetailCell;
       // }
  //  }
  //  return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        CGSize size = [_tweetDetailCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
        return size.height+1;
    }
    return 48;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}


#pragma mark - button handlers

- (void)homeButtonHandler:(id)sender {
    
}

- (void)replyButtonHandler:(id)sender {
    
}

@end
