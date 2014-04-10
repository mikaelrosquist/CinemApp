//
//  PushNotificationsViewController.h
//  CinemApp
//
//  Created by Teodor Östlund on 2014-04-10.
//  Copyright (c) 2014 Rosquist Östlund. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PushNotificationsViewController : UITableViewController<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) NSArray* likesSection;
@property (strong, nonatomic) NSArray* commentsSection;
@property (strong, nonatomic) NSArray* followersSection;

@end
