//
//  HomeViewController.m
//  TabBar
//
//  Created by Teodor Östlund on 2014-02-17.
//  Copyright (c) 2014 Teodor Östlund. All rights reserved.
//

#import "HomeViewController.h"
#import "Parse/Parse.h"
#import "NotLoggedInViewController.h"
#import "ActivityViewController.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

@synthesize activityTable, searchUserView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"News";
        activityTable = [[ActivityViewController alloc]initWithNibName:nil bundle:nil];
        [self.view addSubview:activityTable.view];

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                                  target:self
                                                                                  action:@selector(searchUser:)];
    self.navigationItem.rightBarButtonItem = barButtonItem;
}

-(void)searchUser:(id)sender {
    searchUserView = [[UserSearchViewController alloc] initWithStyle:UITableViewStylePlain];
    [self.navigationController pushViewController:searchUserView animated:YES];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

@end
