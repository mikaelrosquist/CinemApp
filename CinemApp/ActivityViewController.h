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

@property (retain, strong) UIScrollView *scrollView;
@property (retain, strong) UITableViewController *activityTable;
@property (retain, strong) ActivityTableViewCell *activityTableCell;
@property (nonatomic, strong) NSString *movieTitle;
@property (nonatomic, retain) LikeModel *likeModel;


@property (retain, strong) NSMutableArray *posterArray;
@property (retain, strong) NSMutableArray *titleArray;
@property (retain, strong) NSMutableArray *yearArray;
@property (retain, strong) NSMutableArray *ratingsArray;
@property (retain, strong) NSMutableArray *likedArray;

- (id)initWithOneMovie:(NSString *)incomingID :(NSString *) incomingTitle :(NSData *)incomingPoster :(CGFloat)backDropImageHeight;
- (void)retrieveUserRatings;
- (void) likePost: (NSString *)rateID;

@end