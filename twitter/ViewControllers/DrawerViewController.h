//
//  DrawerViewController.h
//  twitter
//
//  Created by Veronica Zheng on 6/30/14.
//  Copyright (c) 2014 Veronica Zheng. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    DrawerMenuItemHeader = 0,
    DrawerMenuItemProfile = 1,
    DrawerMenuItemTimeline = 2,
    DrawerMenuItemMetions = 3,
    DrawerMenuItemLogout = 4
} DrawerMenuItem;

@protocol DrawerViewControllerDelegate <NSObject>

- (void)drawerMenuItemIsSelected:(DrawerMenuItem)menuItem;

@end


@interface DrawerViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) id<DrawerViewControllerDelegate> delegate;

@end
