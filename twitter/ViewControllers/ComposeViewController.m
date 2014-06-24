//
//  ComposeViewController.m
//  twitter
//
//  Created by Veronica Zheng on 6/24/14.
//  Copyright (c) 2014 Veronica Zheng. All rights reserved.
//

#import "ComposeViewController.h"
#import "UIColor+Twitter.h"

@interface ComposeViewController ()

@property (nonatomic) NSInteger characterCount;
@property (nonatomic, strong) UILabel *characterCountLabel;

@end


@implementation ComposeViewController

- (id)init {
    self = [super init];
    if (self) {
        _characterCount = 140;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // setup the navigation bar
    [self.navigationController.navigationBar setBarTintColor:[UIColor twitterLightestGreyColor]];
    [self.navigationController.navigationBar setTintColor:[UIColor twitterBlueColor]];

    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancelButtonHandler:)];
    UIBarButtonItem *tweetButton = [[UIBarButtonItem alloc] initWithTitle:@"Tweet" style:UIBarButtonItemStylePlain target:self action:@selector(tweetButtonHandler:)];
    self.navigationItem.leftBarButtonItem = cancelButton;
    self.navigationItem.rightBarButtonItem = tweetButton;

    _characterCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(228, 15, 60, 14)];
    _characterCountLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _characterCountLabel.text = [NSString stringWithFormat:@"%ld", _characterCount];
    _characterCountLabel.backgroundColor = [UIColor clearColor];
    _characterCountLabel.font = [UIFont fontWithName:@"Helvitica" size:14.0];
    _characterCountLabel.textColor = [UIColor twitterGreyColor];
    [self.navigationController.navigationBar addSubview:_characterCountLabel];
}

#pragma mark - button handlers

- (void)cancelButtonHandler:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)tweetButtonHandler:(id)sender {

}

@end