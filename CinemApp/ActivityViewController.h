//
//  ActivityViewController.h
//  CinemApp
//
//  Created by mikael on 29/04/14.
//  Copyright (c) 2014 Rosquist Östlund. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Parse/Parse.h"
#import "HomeViewController.h"
#import "ActivityTableView.h"
#import "ActivityTableViewCell.h"

@interface ActivityViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *activityTable;
@property (nonatomic, strong) ActivityTableViewCell *activityTableCell;

- (void)retrieveMovieRatings;

@end