//
//  HomeViewController.h
//  TabBar
//
//  Created by Teodor Östlund on 2014-02-17.
//  Copyright (c) 2014 Teodor Östlund. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserSearchViewController.h"
#import "ActivityViewController.h"
#import "Parse/Parse.h"

@class ActivityViewController;

@interface HomeViewController : UIViewController

@property (nonatomic, strong) ActivityViewController *activityTable;
@property (nonatomic, strong) UserSearchViewController *searchUserView;


@end
