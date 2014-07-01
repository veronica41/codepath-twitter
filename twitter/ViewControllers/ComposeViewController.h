//
//  ComposeViewController.h
//  twitter
//
//  Created by Veronica Zheng on 6/24/14.
//  Copyright (c) 2014 Veronica Zheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"

typedef enum {
    TweetTypeNew = 0,
    TweetTypeReply = 1
} TweetType;

@protocol ComposeViewControllerDelegate <NSObject>

- (void)didPostTweet:(Tweet *)tweet;

@end


@interface ComposeViewController : UIViewController <UITextViewDelegate>

@property (nonatomic, strong) Tweet *replyToTweet;
@property (nonatomic, weak) id<ComposeViewControllerDelegate> delegate;

- (id)initWithTweetType:(TweetType)type;

@end
