//
//  ViewController.h
//  JSONiOS
//
//  Created by Kurup, Vishal on 4/14/13.
//  Copyright (c) 2013 conkave. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Movie.h"
#import "RateViewController.h"

@interface RateSearchViewController : UITableViewController
<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSDictionary * json;
@property (nonatomic, strong) NSMutableArray * resultArray;
//@property (nonatomic, strong) NSDictionary * dict;
@property (nonatomic, strong) NSMutableArray* latestLoans;

@property (strong, nonatomic) UITableView *mainTableView;

#pragma mark - Methods
- (void) retrieveData;

@end
