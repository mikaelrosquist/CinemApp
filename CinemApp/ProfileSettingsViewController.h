//
//  SettingsViewController.h
//  CinemApp
//
//  Created by Teodor Östlund on 2014-02-20.
//  Copyright (c) 2014 Rosquist Östlund. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProfileSettingsViewController : UITableViewController<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) NSArray* personalSection;
@property (strong, nonatomic) NSArray* privateProfileSection;
@property (strong, nonatomic) NSArray* removeAccountSection;

@end