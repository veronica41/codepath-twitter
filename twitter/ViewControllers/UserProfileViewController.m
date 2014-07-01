//
//  UserProfileViewController.m
//  twitter
//
//  Created by Veronica Zheng on 6/29/14.
//  Copyright (c) 2014 Veronica Zheng. All rights reserved.
//

#import "UserProfileViewController.h"
#import "UserProfile.h"
#import "TwitterClient.h"
#import "Tweet.h"
#import "TimelineTableViewCell.h"
#import "UIImageView+AFNetworking.h"


static NSString * kUserTimelineCellIdentifier = @"UserTimelineTableViewCell";

@interface UserProfileViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *screenNameLabel;
@property (weak, nonatomic) IBOutlet UITableView *tweetsTableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topImageHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *profileImageTopConstraint;

@property (nonatomic, strong) TimelineTableViewCell *prototypeCell;
@property (nonatomic, strong) UserProfile *userProfile;
@property (nonatomic, strong) NSArray *tweets;

@end

@implementation UserProfileViewController

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

    self.tweetsTableView.dataSource = self;
    self.tweetsTableView.delegate = self;
    UINib *timelineCellNib = [UINib nibWithNibName:kUserTimelineCellIdentifier bundle:nil];
    [self.tweetsTableView registerNib:timelineCellNib forCellReuseIdentifier:kUserTimelineCellIdentifier];
    self.prototypeCell = [self.tweetsTableView dequeueReusableCellWithIdentifier:kUserTimelineCellIdentifier];

    __weak UserProfileViewController *weakSelf = self;
    [self getUserProfileWithCompletionHandler:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.backgroundImageView setImageWithURL:weakSelf.userProfile.profileBackgroundImageUrl];
            [weakSelf.profileImageView setImageWithURL:weakSelf.userProfile.profileImageUrl];
            weakSelf.nameLabel.text = weakSelf.userProfile.name;
            weakSelf.screenNameLabel.text = weakSelf.user.screenNameString;
        });
        [weakSelf loadUserTimelineTweets];
    }];
}

- (void)getUserProfileWithCompletionHandler:(void(^)(void))handler {
    [[TwitterClient instance] getUserProfileWithScreenName:self.user.screenName success:^(AFHTTPRequestOperation *operation, id response) {
        NSError *error = nil;
        self.userProfile = [MTLJSONAdapter modelOfClass:UserProfile.class fromJSONDictionary:response error:&error];
        if (error) {
            NSLog(@"Error in parse json: %@", error);
        } else {
            handler();
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error fetching user profile: %@", error);
    }];
}

- (void)loadUserTimelineTweets {
    __weak UserProfileViewController *weakSelf = self;
    [[TwitterClient instance] UserTimelineWithScreenName:self.user.screenName success:^(AFHTTPRequestOperation *operation, id response) {
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.tweets = [[Tweet tweetsFromJSONArray:response] mutableCopy];
            [weakSelf.tweetsTableView reloadData];
        });
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"usertimeline request error: %@", error);
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tweets.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //if (indexPath.row == 0) {
        
    //} else {
        TimelineTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kUserTimelineCellIdentifier forIndexPath:indexPath];
        cell.tweet = self.tweets[indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    //}
    return nil;
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




@end
