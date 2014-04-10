//
//  PushNotificationsViewController.h
//  CinemApp
//
//  Created by Teodor Östlund on 2014-04-10.
//  Copyright (c) 2014 Rosquist Östlund. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PushNotificationsViewController : UITableViewController<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) NSArray* notificationsSection;

@end
