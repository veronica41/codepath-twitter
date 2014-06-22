//
//  TTTimelineViewController.m
//  twitter
//
//  Created by Veronica Zheng on 6/22/14.
//  Copyright (c) 2014 Veronica Zheng. All rights reserved.
//

#import "TTTimelineViewController.h"
#import "TTUser.h"

@interface TTTimelineViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

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

    // setup navigation bar
    UIBarButtonItem *signOutButton = [[UIBarButtonItem alloc] initWithTitle:@"Sign Out" style:UIBarButtonItemStylePlain target:self action:@selector(signOutButtonHandler:)];
    UIBarButtonItem *newButton = [[UIBarButtonItem alloc] initWithTitle:@"New" style:UIBarButtonItemStylePlain target:self action:@selector(newButtonHandler:)];
    self.navigationItem.title = @"Home";
    self.navigationItem.leftBarButtonItem = signOutButton;
    self.navigationItem.rightBarButtonItem = newButton;
}

#pragma mark - Button handlers

- (void)signOutButtonHandler:(id)sender {
    [TTUser setCurrentUser:nil];
}

- (void)newButtonHandler:(id)sender {
    
}
@end
