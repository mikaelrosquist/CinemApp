//
//  MovieTableViewController.h
//  CinemApp
//
//  Created by mikael on 08/04/14.
//  Copyright (c) 2014 Rosquist Östlund. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MovieTableView.h"
#import "MovieView.h"
#import "RateViewController.h"

@interface MovieTableViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate>

- (id)initWithData:(UITableViewStyle)style
                  :(NSArray *)personArray;

- (void)makeTableView:(UITableView *)table;

@property (nonatomic, strong) UITableView *personTable;
@property (nonatomic, strong) NSArray *personArray;

@end
