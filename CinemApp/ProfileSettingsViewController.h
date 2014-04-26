//
//  SettingsViewController.h
//  CinemApp
//
//  Created by Teodor Östlund on 2014-02-20.
//  Copyright (c) 2014 Rosquist Östlund. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PasswordViewController.h"

@interface ProfileSettingsViewController : UITableViewController<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>

@property (strong, nonatomic) NSArray* personalSection;
@property (strong, nonatomic) NSArray* passwordSection;
@property (strong, nonatomic) NSArray* privateProfileSection;
@property (strong, nonatomic) NSArray* removeAccountSection;

@property (nonatomic, strong) PasswordViewController *passwordSettingsView;

@end