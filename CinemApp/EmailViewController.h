//
//  SettingsViewController.h
//  CinemApp
//
//  Created by Teodor Östlund on 2014-02-20.
//  Copyright (c) 2014 Rosquist Östlund. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EmailViewController : UITableViewController<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>

@property (strong, nonatomic) NSArray* emailSection;
@property (strong, nonatomic) NSArray* passwordSection;


@end