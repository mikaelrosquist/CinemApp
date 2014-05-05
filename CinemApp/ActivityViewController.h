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
#import "LikeModel.h"

@interface ActivityViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>{
    LikeModel *likeModel;
}

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UITableViewController *activityTable;
@property (nonatomic, strong) ActivityTableViewCell *activityTableCell;
@property (nonatomic, strong) NSString *movieTitle;
@property (nonatomic, retain) LikeModel *likeModel;


- (id)initWithOneMovie:(NSString *)incomingID :(NSString *) incomingTitle :(NSData *)incomingPoster :(CGFloat)backDropImageHeight;
- (void)retrieveUserRatings;
- (void) likePost: (NSString *)rateID;

@end