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
        self.title = @"CinemApp";
        activityTable = [[ActivityViewController alloc]initWithNibName:nil bundle:nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view addSubview:activityTable.view];
    
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                                  target:self
                                                                                  action:@selector(searchUser:)];
    self.navigationItem.rightBarButtonItem = barButtonItem;
    
    //Byter färg på navigationBar
    //self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:1.000 green:0.314 blue:0.329 alpha:1];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.navigationController.navigationBar setTintColor:[UIColor colorWithRed:0.855 green:0.243 blue:0.251 alpha:1]];

    /* if (![PFUser currentUser]) {
     LogInViewController *loginView = [[LogInViewController alloc] init];
     loginView.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
     [self presentViewController:loginView animated:YES completion:nil];
     }*/
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)searchUser:(id)sender {
    searchUserView = [[UserSearchViewController alloc] initWithStyle:UITableViewStylePlain];
    [self.navigationController pushViewController:searchUserView animated:YES];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

@end
