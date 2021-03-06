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
#import "UserStatsCell.h"
#import "Tweet.h"
#import "TimelineTableViewCell.h"
#import "UIImageView+AFNetworking.h"
#import "UIImage+StackBlur.h"

static NSString * kUserTimelineCellIdentifier = @"TimelineTableViewCell";
static NSString * kUserStatsCellIdentifier = @"UserStatsCell";

static CGFloat kHeaderImageMaxHeight = 330;

@interface UserProfileViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *screenNameLabel;
@property (weak, nonatomic) IBOutlet UITableView *tweetsTableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headerImageHeightConstraint;

@property (nonatomic, strong) TimelineTableViewCell *prototypeCell;
@property (nonatomic, strong) UIView *tableHeaderView;
@property (nonatomic) CGRect headerFrame;

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

    // setup the navigation bar
    self.navigationItem.title = @"Profile";

    // setup table view
    self.tableHeaderView = [[[NSBundle mainBundle] loadNibNamed:@"ProfileHeaderView" owner:self options:nil] lastObject];
    self.headerFrame = self.tableHeaderView.frame;
    UIPanGestureRecognizer *headerPan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(onPanHeader:)];
    self.tableHeaderView.userInteractionEnabled = YES;
    [self.tableHeaderView  addGestureRecognizer:headerPan];
    
    [self.tweetsTableView setTableHeaderView:self.tableHeaderView];
    self.tweetsTableView.dataSource = self;
    self.tweetsTableView.delegate = self;

    UINib *timelineCellNib = [UINib nibWithNibName:kUserTimelineCellIdentifier bundle:nil];
    [self.tweetsTableView registerNib:timelineCellNib forCellReuseIdentifier:kUserTimelineCellIdentifier];
    self.prototypeCell = [self.tweetsTableView dequeueReusableCellWithIdentifier:kUserTimelineCellIdentifier];

    UINib *userStatsCellNib = [UINib nibWithNibName:kUserStatsCellIdentifier bundle:nil];
    [self.tweetsTableView registerNib:userStatsCellNib forCellReuseIdentifier:kUserStatsCellIdentifier];

    [self.view layoutSubviews];
    self.tableHeaderView.frame = self.headerFrame;
    [self.tweetsTableView setTableHeaderView:self.tableHeaderView];

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
            self.tableHeaderView.frame = self.headerFrame;
            [self.tweetsTableView setTableHeaderView:self.tableHeaderView];
        });
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"usertimeline request error: %@", error);
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }
    return self.tweets.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        UserStatsCell *cell = [tableView dequeueReusableCellWithIdentifier:kUserStatsCellIdentifier];
        [cell setUserProfile:self.userProfile];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    } else {
        TimelineTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kUserTimelineCellIdentifier forIndexPath:indexPath];
        cell.tweet = self.tweets[indexPath.row];
        return cell;
    }
    return nil;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 151;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        self.prototypeCell.tweet = self.tweets[indexPath.row];
        CGSize size = [self.prototypeCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
        return size.height+1;
    }
    return 64;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        TimelineTableViewCell * cell = (TimelineTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
        TweetViewController * tweetController = [[TweetViewController alloc] init];
        tweetController.tweet = cell.tweet;
        tweetController.delegate = cell;
        [self.navigationController pushViewController:tweetController animated:YES];
        [self.navigationController.view clipsToBounds];
    }
}

- (IBAction)onPanHeader:(UIPanGestureRecognizer *)sender {
    CGPoint translation = [sender translationInView:self.view];
    if (translation.y > 0) {
        CGRect frame = self.tableHeaderView.frame;
        frame.size.height += translation.y;
        if (frame.size.height <= kHeaderImageMaxHeight) {
            self.tableHeaderView.frame = frame;
            [self.tweetsTableView setTableHeaderView:self.tableHeaderView];
        }
        //CGFloat radius = frame.size.height - self.headerFrame.size.height;
        //[self.backgroundImageView.image stackBlur:radius/5];
    }
    if (sender.state == UIGestureRecognizerStateEnded) {
        self.tableHeaderView.frame = self.headerFrame;
        [self.tweetsTableView setTableHeaderView:self.tableHeaderView];
    }
    [sender setTranslation:CGPointMake(0, 0) inView:self.view];
}
@end
