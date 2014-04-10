//
//  SettingsViewController.h
//  CinemApp
//
//  Created by Teodor Östlund on 2014-02-20.
//  Copyright (c) 2014 Rosquist Östlund. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PasswordViewController.h"

@interface AccountSettingsViewController : UITableViewController<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) NSArray* passwordSection;
@property (strong, nonatomic) NSArray* removeAccountSection;

@property (nonatomic, strong) PasswordViewController *passwordSettingsView;

@end