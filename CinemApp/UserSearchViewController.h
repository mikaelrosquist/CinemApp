//
//  PeopleSearchViewController.h
//  CinemApp
//
//  Created by Teodor Östlund on 2014-04-29.
//  Copyright (c) 2014 Rosquist Östlund. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserSearchViewController : UITableViewController<UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UISearchDisplayDelegate>

@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) NSArray *usersArray;

@end
