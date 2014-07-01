//
//  TTTimelineViewController.m
//  twitter
//
//  Created by Veronica Zheng on 6/22/14.
//  Copyright (c) 2014 Veronica Zheng. All rights reserved.
//

#import "TimelineViewController.h"
#import "UserProfileViewController.h"
#import "User.h"
#import "Tweet.h"
#import "MBProgressHUD.h"
#import "SVPullToRefresh.h"
#import "DrawerViewController.h"

static NSString * timelineCellIdentifier = @"TimelineTableViewCell";

@interface TimelineViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *tweets;
@property (nonatomic, strong) TimelineTableViewCell *prototypeCell;

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
    UIBarButtonItem *menuButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"hamburger"] style:UIBarButtonItemStylePlain target:self action:@selector(onMenuButton:)];
    UIBarButtonItem *newButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"compose"] style:UIBarButtonItemStylePlain target:self action:@selector(onNewButton:)];
    self.navigationItem.title = @"Home";
    self.navigationItem.leftBarButtonItem = menuButton;
    self.navigationItem.rightBarButtonItem = newButton;

    // setup the table view
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    UINib *timelineCellNib = [UINib nibWithNibName:timelineCellIdentifier bundle:nil];
    [self.tableView registerNib:timelineCellNib forCellReuseIdentifier:timelineCellIdentifier];
    self.prototypeCell = [_tableView dequeueReusableCellWithIdentifier:timelineCellIdentifier];

    __weak TimelineViewController *weakSelf = self;

    // setup pull to refresh
    [self.tableView addPullToRefreshWithActionHandler:^{
        [weakSelf loadTweetsWithCompletionHandler:^{
            [weakSelf.tableView.pullToRefreshView stopAnimating];
        }];
    }];

    // setup infinite scroll
    [self.tableView addInfiniteScrollingWithActionHandler:^{
        [weakSelf loadMoreTweetsWithCompletionHandler:^{
            [weakSelf.tableView.infiniteScrollingView stopAnimating];
        }];
    }];

    // load initial tweets
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self loadTweetsWithCompletionHandler:^{
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
    }];
}

#pragma mark - Load tweets

- (void)loadTweetsWithCompletionHandler:(void(^)(void))completionHandler {
    __weak TimelineViewController *weakSelf = self;

    [[TwitterClient instance] TimelineWithType:self.type maxId:nil success:^(AFHTTPRequestOperation *operation, id response) {
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.tweets = [[Tweet tweetsFromJSONArray:response] mutableCopy];
            [weakSelf.tableView reloadData];
            completionHandler();
        });
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"home timeline request error: %@", error);
            completionHandler();
        });
    }];
}

- (void)loadMoreTweetsWithCompletionHandler:(void(^)(void))completionHandler {
    __weak TimelineViewController *weakSelf = self;
    NSString * lastTweetID= ((Tweet *)[self.tweets lastObject]).tweetID;
    long long maxID = [lastTweetID longLongValue] - 1;

    [[TwitterClient instance]  TimelineWithType:self.type maxId:[@(maxID) stringValue] success:^(AFHTTPRequestOperation *operation, id response) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSArray *newTweets = [Tweet tweetsFromJSONArray:response];
            NSInteger oldTweetsCount = weakSelf.tweets.count;
            if (newTweets.count > 0) {
                weakSelf.tweets = [weakSelf.tweets arrayByAddingObjectsFromArray:newTweets];
            }

            // insert new rows
            NSMutableArray *indexPaths = [NSMutableArray array];
            for (NSInteger i = oldTweetsCount; i < weakSelf.tweets.count; i++) {
                [indexPaths addObject:[NSIndexPath indexPathForRow:i inSection:0]];
            }
            [weakSelf.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
            completionHandler();
        });
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"home timeline request error: %@", error);
            completionHandler();
        });
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tweets.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TimelineTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:timelineCellIdentifier forIndexPath:indexPath];
    cell.tweet = self.tweets[indexPath.row];
    cell.delegate = self;
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 151;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    self.prototypeCell.tweet = self.tweets[indexPath.row];
    CGSize size = [self.prototypeCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    return size.height+1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    TimelineTableViewCell * cell = (TimelineTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    TweetViewController * tweetController = [[TweetViewController alloc] init];
    tweetController.tweet = cell.tweet;
    tweetController.delegate = cell;
    [self.navigationController pushViewController:tweetController animated:YES];
    [self.navigationController.view clipsToBounds];
}

#pragma mark - TimelineTableViewCellDelegate

- (void)didTapProfileImageForUser:(User *)user {
    UserProfileViewController *profileController = [[UserProfileViewController alloc] init];
    profileController.user = user;
    [self.navigationController pushViewController:profileController animated:YES];
    [self.navigationController.view clipsToBounds];
}

#pragma mark - ComposeViewControllerDelegate

- (void)didPostTweet:(Tweet *)tweet {
    NSArray *newTweets = @[tweet];
    self.tweets = [newTweets arrayByAddingObjectsFromArray:self.tweets];
    [self.tableView reloadData];
}

#pragma mark - Button handlers

- (void)onMenuButton:(id)sender {
}

- (void)onNewButton:(id)sender {
    ComposeViewController * controller = [[ComposeViewController alloc] initWithTweetType:TweetTypeNew];
    controller.delegate = self;
    UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:controller];
    [self presentViewController:nvc animated:YES completion:nil];
}

@end
