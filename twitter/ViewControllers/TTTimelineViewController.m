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

static NSString * timelineCellIdentifier = @"TTTimelineTableViewCell";

@interface TTTimelineViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *tweets;

@property (nonatomic, strong) TTTimelineTableViewCell *prototypeCell;

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
}

- (void)reload {
    [[TTTwitterClient instance] homeTimelineWithCount:20 sinceId:0 maxId:0 success:^(AFHTTPRequestOperation *operation, id response) {
        _tweets = [TTTweet tweetsFromJSONArray:response];
        [_tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"home timeline request error: %@", error);
    }];
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _tweets.count;
}

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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TTTimelineTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:timelineCellIdentifier forIndexPath:indexPath];
    cell.tweet = _tweets[indexPath.row];
    return cell;
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
