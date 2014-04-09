//
//  SettingsViewController.h
//  CinemApp
//
//  Created by Teodor Östlund on 2014-02-20.
//  Copyright (c) 2014 Rosquist Östlund. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsViewController : UITableViewController<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSArray* accountSection;
@property (strong, nonatomic) NSArray* generalSection;
@property (strong, nonatomic) NSArray* aboutSection;



@end