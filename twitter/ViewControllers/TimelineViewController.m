//
//  TTTimelineViewController.m
//  twitter
//
//  Created by Veronica Zheng on 6/22/14.
//  Copyright (c) 2014 Veronica Zheng. All rights reserved.
//

#import "TimelineViewController.h"
#import "TwitterClient.h"
#import "User.h"
#import "Tweet.h"
#import "TimelineTableViewCell.h"
#import "TweetViewController.h"
#import "MBProgressHUD.h"

static NSString * timelineCellIdentifier = @"TimelineTableViewCell";

@interface TimelineViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *tweets;
@property (nonatomic, strong) TimelineTableViewCell *prototypeCell;
@property (nonatomic, strong) UIRefreshControl *refreshControl;

@end

@implementation TimelineViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // setup the navigation bar
    UIBarButtonItem *signOutButton = [[UIBarButtonItem alloc] initWithTitle:@"Sign Out" style:UIBarButtonItemStylePlain target:self action:@selector(signOutButtonHandler:)];
    UIBarButtonItem *newButton = [[UIBarButtonItem alloc] initWithTitle:@"New" style:UIBarButtonItemStylePlain target:self action:@selector(newButtonHandler:)];
    self.navigationItem.title = @"Home";
    self.navigationItem.leftBarButtonItem = signOutButton;
    self.navigationItem.rightBarButtonItem = newButton;

    // setup the table view
    _tableView.dataSource = self;
    _tableView.delegate = self;
    UINib *timelineCellNib = [UINib nibWithNibName:timelineCellIdentifier bundle:nil];
    [_tableView registerNib:timelineCellNib forCellReuseIdentifier:timelineCellIdentifier];
    _prototypeCell = [_tableView dequeueReusableCellWithIdentifier:timelineCellIdentifier];
    [self reload];

    // setup refresh control
    _refreshControl = [[UIRefreshControl alloc] init];
    [_refreshControl addTarget:self action:@selector(reload) forControlEvents:UIControlEventValueChanged];
    [_tableView addSubview:_refreshControl];
}

- (void)reload {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[TwitterClient instance] homeTimelineWithCount:20 sinceId:0 maxId:0 success:^(AFHTTPRequestOperation *operation, id response) {
        dispatch_async(dispatch_get_main_queue(), ^{
            _tweets = [Tweet tweetsFromJSONArray:response];
            [_tableView reloadData];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [_refreshControl endRefreshing];
        });
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"home timeline request error: %@", error);
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [_refreshControl endRefreshing];
        });
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _tweets.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TimelineTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:timelineCellIdentifier forIndexPath:indexPath];
    cell.tweet = _tweets[indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 151;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    _prototypeCell.tweet = _tweets[indexPath.row];
    CGSize size = [_prototypeCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    return size.height+1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    TimelineTableViewCell * cell = (TimelineTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    TweetViewController * tweetController = [[TweetViewController alloc] initWithTweet:_tweets[indexPath.row] andProfileImage:cell.profileImage.image];
    [self.navigationController pushViewController:tweetController animated:YES];
    [self.navigationController.view clipsToBounds];
}

#pragma mark - Button handlers

- (void)signOutButtonHandler:(id)sender {
    [User setCurrentUser:nil];
}

- (void)newButtonHandler:(id)sender {
    
}
@end
