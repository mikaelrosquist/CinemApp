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

@interface MovieTableViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

- (id)viewDidLoad:(NSArray *)castArray;
- (id)initWithData:(NSMutableArray*)castArray;
- (CGFloat)tableViewHeight;

@property (nonatomic, strong) UITableView *personTable;
@property (nonatomic, strong) NSMutableArray *personArray;
@property (nonatomic, strong) UIView *movieTableView;

@end
