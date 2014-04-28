//
//  LogInViewController.m
//  CinemApp
//
//  Created by Teodor Östlund on 2014-04-28.
//  Copyright (c) 2014 Rosquist Östlund. All rights reserved.
//

#import "LogInViewController.h"
#import "Parse/Parse.h"
#import "DejalActivityView.h"
#import "AppDelegate.h"

@interface LogInViewController ()

@end

@implementation LogInViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Log in";
    [self.view setBackgroundColor:[UIColor whiteColor]];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleDefault;
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [DejalActivityView activityViewForView:self.view withLabel:@"Logging in..."].showNetworkActivityIndicator = YES;
    [PFUser logInWithUsernameInBackground:@"testuser" password:@"admin"
                                    block:^(PFUser *user, NSError *error) {
                                        if (user) {
                                            NSLog(@"Inloggning lyckades!");
                                            AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                                            [appDelegate setupTabBarController];
                                            [[self presentingViewController] dismissViewControllerAnimated:YES completion:nil];
                                        } else {
                                            NSLog(@"Inloggning misslyckades!");
                                        }
                                    }];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;

    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
