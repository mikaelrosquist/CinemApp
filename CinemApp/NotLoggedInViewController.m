//
//  LogInViewController.m
//  CinemApp
//
//  Created by Teodor Östlund on 2014-02-21.
//  Copyright (c) 2014 Rosquist Östlund. All rights reserved.
//

#import "NotLoggedInViewController.h"
#import "DejalActivityView.h"
#import "Parse/Parse.h"

@interface NotLoggedInViewController ()

@end

@implementation NotLoggedInViewController{
    UIButton *logInButton, *signUpButton;
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
    
    UIImageView *backgroundImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login-bg"]];
    
    [self.view addSubview:backgroundImage];
    [self.view sendSubviewToBack:backgroundImage];
    
    signUpButton = [UIButton buttonWithType:UIButtonTypeCustom];
    signUpButton.frame = CGRectMake(20.0, 260.0, 280.0, 40.0);
    [signUpButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    signUpButton.backgroundColor = [UIColor colorWithRed:1.000 green:1.000 blue:1.000 alpha:0.4];
    signUpButton.layer.borderWidth = 0;
    signUpButton.layer.cornerRadius = 2.0f;
    [signUpButton addTarget:self
                     action:@selector(signUp:)
           forControlEvents:UIControlEventTouchUpInside];
    [signUpButton setTitle:@"Register with Email" forState:UIControlStateNormal];
    
    
    logInButton = [UIButton buttonWithType:UIButtonTypeCustom];
    logInButton.frame = CGRectMake(20.0, 310.0, 280.0, 40.0);
        [logInButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    logInButton.backgroundColor = [UIColor colorWithRed:0.000 green:1.000 blue:0.494 alpha:0.4];
    logInButton.layer.borderWidth = 0;
    logInButton.layer.cornerRadius = 2.0f;
    [logInButton addTarget:self
                    action:@selector(logIn:)
          forControlEvents:UIControlEventTouchUpInside];
    [logInButton setTitle:@"Log In" forState:UIControlStateNormal];
    
    
    [self.view addSubview:signUpButton];
    [self.view addSubview:logInButton];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)logIn:(id)sender {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [logInButton removeFromSuperview];
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

- (void)signUp:(id)sender {
    
}


@end
