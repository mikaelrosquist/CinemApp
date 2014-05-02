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
        //activityTable = [[ActivityViewController alloc]initWithNibName:nil bundle:nil];
        //[self.view addSubview:activityTable.view];

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"searchUser"]
                                                                     style:UIBarButtonItemStylePlain
                                                                    target:self
                                                                    action:@selector(searchUser:)];


    self.navigationItem.rightBarButtonItem = barButtonItem;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
    UIImage *_defaultImage;
    [self.navigationController.navigationBar setBackgroundImage:_defaultImage forBarMetrics:UIBarMetricsDefault];
}

-(void)searchUser:(id)sender {
    searchUserView = [[UserSearchViewController alloc] initWithStyle:UITableViewStylePlain];
    [self.navigationController pushViewController:searchUserView animated:YES];
}

@end
