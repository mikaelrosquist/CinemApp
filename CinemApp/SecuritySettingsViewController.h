//
//  SecuritySettingsViewController.h
//  CinemApp
//
//  Created by Teodor Östlund on 2014-04-30.
//  Copyright (c) 2014 Rosquist Östlund. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PasswordViewController.h"
#import "EmailViewController.h"

@interface SecuritySettingsViewController : UITableViewController<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>

@property (nonatomic, strong) PasswordViewController *passwordSettingsView;
@property (nonatomic, strong) EmailViewController *emailSettingsView;

@end
