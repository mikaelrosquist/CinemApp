//
//  SettingsViewController.h
//  CinemApp
//
//  Created by Teodor Östlund on 2014-02-20.
//  Copyright (c) 2014 Rosquist Östlund. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProfileSettingsViewController.h"

@interface SettingsRootViewController : UITableViewController<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSArray* accountSection;
@property (strong, nonatomic) NSArray* generalSection;
@property (strong, nonatomic) NSArray* aboutSection;

@property (nonatomic, strong) ProfileSettingsViewController *profileSettingsView;

@end