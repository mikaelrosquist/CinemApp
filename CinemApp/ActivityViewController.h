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

@property (retain, strong) UIScrollView *scrollView;
@property (retain, strong) UITableViewController *activityTable;
@property (retain, strong) ActivityTableViewCell *activityTableCell;
@property (nonatomic, strong) NSString *movieTitle;

@property (retain, strong) NSMutableArray *posterArray;
@property (retain, strong) NSMutableArray *titleArray;
@property (retain, strong) NSMutableArray *yearArray;
@property (retain, strong) NSMutableArray *ratingsArray;

- (id)initWithOneMovie:(NSString *)incomingID :(NSString *) incomingTitle :(NSData *)incomingPoster :(CGFloat)backDropImageHeight;
- (void)retrieveUserRatings;

@end