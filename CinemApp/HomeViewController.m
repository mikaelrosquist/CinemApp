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
#import "UserSearchViewController.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"CinemApp";

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
    
    //Byter färg på navigationBar
    //self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:1.000 green:0.314 blue:0.329 alpha:1];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
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
    UserSearchViewController *searchUserView = [[UserSearchViewController alloc] init];
    [self.navigationController pushViewController:searchUserView animated:YES];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

@end
