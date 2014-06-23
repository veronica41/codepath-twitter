//
//  TTTimelineViewController.m
//  twitter
//
//  Created by Veronica Zheng on 6/22/14.
//  Copyright (c) 2014 Veronica Zheng. All rights reserved.
//

#import "TTTimelineViewController.h"
#import "TTTwitterClient.h"
#import "TTUser.h"
#import "TTTweet.h"
#import "TTTimelineTableViewCell.h"
#import "MBProgressHUD.h"

static NSString * timelineCellIdentifier = @"TTTimelineTableViewCell";

@interface TTTimelineViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *tweets;
@property (nonatomic, strong) TTTimelineTableViewCell *prototypeCell;
@property (nonatomic, strong) UIRefreshControl *refreshControl;

@end

@implementation TTTimelineViewController

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
    [[TTTwitterClient instance] homeTimelineWithCount:20 sinceId:0 maxId:0 success:^(AFHTTPRequestOperation *operation, id response) {
        dispatch_async(dispatch_get_main_queue(), ^{
            _tweets = [TTTweet tweetsFromJSONArray:response];
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
    TTTimelineTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:timelineCellIdentifier forIndexPath:indexPath];
    cell.tweet = _tweets[indexPath.row];
    if (!cell.tweet.retweetedLabelString) {
        NSLog(@"%d : %@", indexPath.row, cell.tweet.tweetString);
    }
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForFooterInSection:(NSInteger)section {
    return 151;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    _prototypeCell.tweet = _tweets[indexPath.row];
    CGSize size = [_prototypeCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    return size.height+1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark - Button handlers

- (void)signOutButtonHandler:(id)sender {
    [TTUser setCurrentUser:nil];
}

- (void)newButtonHandler:(id)sender {
    
}
@end
