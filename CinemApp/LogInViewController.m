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

@implementation LogInViewController{
    UIButton *button;
}

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
    
    button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button addTarget:self
               action:@selector(logIn:)
     forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"Log in" forState:UIControlStateNormal];
    button.frame = CGRectMake(80.0, 210.0, 160.0, 40.0);
    [self.view addSubview:button];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)logIn:(id)sender {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [button removeFromSuperview];
    [DejalActivityView activityViewForView:self.view withLabel:@"Logging in..."].showNetworkActivityIndicator = YES;
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


@end
