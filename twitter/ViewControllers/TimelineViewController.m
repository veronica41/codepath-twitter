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
#import "MBProgressHUD.h"
#import "SVPullToRefresh.h"

static NSString * timelineCellIdentifier = @"TimelineTableViewCell";

@interface TimelineViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *tweets;
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
    UIBarButtonItem *signOutButton = [[UIBarButtonItem alloc] initWithTitle:@"Sign Out" style:UIBarButtonItemStylePlain target:self action:@selector(signOutButtonHandler:)];
    UIBarButtonItem *newButton = [[UIBarButtonItem alloc] initWithTitle:@"New" style:UIBarButtonItemStylePlain target:self action:@selector(newButtonHandler:)];
    self.navigationItem.title = @"Home";
    self.navigationItem.leftBarButtonItem = signOutButton;
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
        [weakSelf loadNewTweetsWithCompletionHandler:^{
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
    [self loadInitialTweetsWithCompletionHandler:^{
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
    }];
}

#pragma mark - Load tweets

- (void)loadInitialTweetsWithCompletionHandler:(void(^)(void))completionhandler {
    __weak TimelineViewController *weakSelf = self;

    [[TwitterClient instance] homeTimelineWithCount:20 sinceId:0 maxId:0 success:^(AFHTTPRequestOperation *operation, id response) {
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.tweets = [[Tweet tweetsFromJSONArray:response] mutableCopy];
            [weakSelf.tableView reloadData];
            completionhandler();
        });
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"home timeline request error: %@", error);
            completionhandler();
        });
    }];
}

- (void)loadNewTweetsWithCompletionHandler:(void(^)(void))completionHandler {
    
}

- (void)loadMoreTweetsWithCompletionHandler:(void(^)(void))completionHandler {
    
}

#pragma mark - UITableViewDataSource

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tweets.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TimelineTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:timelineCellIdentifier forIndexPath:indexPath];
    cell.tweet = self.tweets[indexPath.row];
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
    // TODO: we will get into trouble if the user click the newly created status, go to the tweet detail view,
    // and try to retweet or favorite from there !!!

    TimelineTableViewCell * cell = (TimelineTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    TweetViewController * tweetController = [[TweetViewController alloc] initWithTweet:self.tweets[indexPath.row] andProfileImage:nil];
                                             //cell.profileImage.image];
    tweetController.delegate = self;
    [self.navigationController pushViewController:tweetController animated:YES];
    [self.navigationController.view clipsToBounds];
}

#pragma mark - ComposeViewControllerDelegate

- (void)createNewTweetWithStatus:(NSString *)status {
    User *user = [User currentUser];
    Tweet *tweet = [[Tweet alloc] init];
    tweet.user = user;
    tweet.text = status;
    [self.tweets insertObject:tweet atIndex:0];
    [self.tableView reloadData];
}

#pragma mark - TweetViewControllerDelegate

- (void)retweetedStateChanged:(Tweet *)tweet {
    [_tweets enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        Tweet *t = (Tweet *)obj;
        if ([t.tweetID isEqualToString:tweet.tweetID]) {
            t.retweeted = tweet.retweeted;
            [_tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForItem:idx inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
            *stop = YES;
        }
    }];
}

- (void)favoritedStateChanged:(Tweet *)tweet {
    [_tweets enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        Tweet *t = (Tweet *)obj;
        if ([t.tweetID isEqualToString:tweet.tweetID]) {
            t.favorited = tweet.favorited;
            [_tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForItem:idx inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
            *stop = YES;
        }
    }];
}

#pragma mark - Button handlers

- (void)signOutButtonHandler:(id)sender {
    [User setCurrentUser:nil];
}

- (void)newButtonHandler:(id)sender {
    ComposeViewController * controller = [[ComposeViewController alloc] initWithTweetType:TweetTypeNew Tweet:nil];
    controller.delegate = self;
    UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:controller];
    [self presentViewController:nvc animated:YES completion:nil];
}
@end
