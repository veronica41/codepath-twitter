//
//  DrawerViewController.m
//  twitter
//
//  Created by Veronica Zheng on 6/30/14.
//  Copyright (c) 2014 Veronica Zheng. All rights reserved.
//

#import "DrawerViewController.h"
#import "User.h"
#import "UIImageView+AFNetworking.h"

static NSString * kDrawerCellIdentifier = @"drawerCellIdentifier";
static NSString * kDrawerHeaderCellIdentifier = @"drawerHeaderCellIdentifier";

@interface DrawerViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end


@implementation DrawerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.view.backgroundColor = [UIColor clearColor];
        self.view.clipsToBounds = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // setup table view
    self.tableView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kDrawerCellIdentifier];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 72;
    }
    return 48;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    //make cell background clear; need to do it here because tableView won't do clear cells in cellForRowAtIndexPath
    cell.backgroundColor = [UIColor clearColor];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == DrawerMenuItemHeader) {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:kDrawerHeaderCellIdentifier];
        User *user = [User currentUser];
        [cell.imageView setImageWithURL:user.profileImageUrl placeholderImage:[UIImage imageNamed:@"profile"]];
        cell.textLabel.font = [UIFont fontWithName:@"Helvetica-bold" size:14];
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.textLabel.text = user.name;
        cell.detailTextLabel.font = [UIFont fontWithName:@"Helvetica" size:13];
        cell.detailTextLabel.textColor = [UIColor whiteColor];
        cell.detailTextLabel.text = user.screenNameString;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }

    UITableViewCell * cell = [self.tableView dequeueReusableCellWithIdentifier:kDrawerCellIdentifier];
    [cell.textLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:14]];
    [cell.textLabel setTextColor:[UIColor whiteColor]];
    switch (indexPath.row) {
        case DrawerMenuItemProfile:
            cell.textLabel.text = @"Profile";
            break;
        case DrawerMenuItemTimeline:
            cell.textLabel.text = @"Timeline";
            break;
        case DrawerMenuItemMetions:
            cell.textLabel.text = @"Mentions";
            break;
        case DrawerMenuItemLogout:
            cell.textLabel.text = @"Logout";
            break;
        default:
            break;
    }
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == DrawerMenuItemLogout) {
        [User setCurrentUser:nil];
    }
    [self.delegate drawerMenuItemIsSelected:(DrawerMenuItem)indexPath.row];
}

@end
