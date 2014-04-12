//
//  LogInViewController.m
//  CinemApp
//
//  Created by Teodor Östlund on 2014-02-21.
//  Copyright (c) 2014 Rosquist Östlund. All rights reserved.
//

#import "LogInViewController.h"
#import "DejalActivityView.h"
#import "Parse/Parse.h"

@interface LogInViewController ()

@end

@implementation LogInViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [DejalActivityView activityViewForView:self.view withLabel:@"Logging in..."].showNetworkActivityIndicator = YES;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [PFUser logInWithUsernameInBackground:@"testuser" password:@"admin"
                                    block:^(PFUser *user, NSError *error) {
                                        if (user) {
                                            NSLog(@"Inloggning lyckades!");
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
