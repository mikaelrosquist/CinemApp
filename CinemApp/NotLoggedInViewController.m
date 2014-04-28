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
#import "AppDelegate.h"

#define BUTTON_WIDTH 280.0
#define BUTTON_HEIGHT 40.0
#define BUTTON_BORDER 0.0
#define BUTTON_RADIUS 2.0
#define BUTTON_SPACING 50.0

@interface NotLoggedInViewController ()

@end

@implementation NotLoggedInViewController{
    UIButton *logInButton, *signUpButton;
}

@synthesize signUpWithEmailViewController, logInViewController;

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
    [self.navigationController.navigationBar setTintColor:[UIColor colorWithRed:0.855 green:0.243 blue:0.251 alpha:1]];
    self.navigationController.navigationBar.translucent = YES;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
    
    signUpButton = [UIButton buttonWithType:UIButtonTypeCustom];
     logInButton = [UIButton buttonWithType:UIButtonTypeCustom];
    signUpButton.frame = CGRectMake(20.0, 250.0, BUTTON_WIDTH, BUTTON_HEIGHT);
    logInButton.frame = CGRectMake(20.0, 300.0, BUTTON_WIDTH, BUTTON_HEIGHT);
    [signUpButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [logInButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    signUpButton.layer.borderWidth = BUTTON_BORDER;
    logInButton.layer.borderWidth = BUTTON_BORDER;
    signUpButton.layer.cornerRadius = BUTTON_RADIUS;
    logInButton.layer.cornerRadius = BUTTON_RADIUS;
    [signUpButton.titleLabel setFont: [UIFont fontWithName: @"HelveticaNeue-Medium" size: 14.0]];
    [logInButton.titleLabel setFont: [UIFont fontWithName: @"HelveticaNeue-Medium" size: 14.0]];
    
    [signUpButton setTitle:@"Register with Email" forState:UIControlStateNormal];
    [logInButton setTitle:@"Log In" forState:UIControlStateNormal];

    [signUpButton setBackgroundColor:[UIColor colorWithRed:1.000 green:1.000 blue:1.000 alpha:0.3]];
    [logInButton setBackgroundColor:[UIColor colorWithRed:0.000 green:1.000 blue:0.494 alpha:0.5]];

    
    [signUpButton addTarget:self action:@selector(signUp:) forControlEvents:UIControlEventTouchUpInside];
    [signUpButton addTarget:self action:@selector(setBgColorForButton:) forControlEvents:UIControlEventTouchDown];
    [signUpButton addTarget:self action:@selector(clearBgColorForButton:) forControlEvents:UIControlEventTouchDragExit];
    
    [logInButton addTarget:self action:@selector(logIn:) forControlEvents:UIControlEventTouchUpInside];
    [logInButton addTarget:self action:@selector(setBgColorForButton:) forControlEvents:UIControlEventTouchDown];
    [logInButton addTarget:self action:@selector(clearBgColorForButton:) forControlEvents:UIControlEventTouchDragExit];
    
    [self.view addSubview:signUpButton];
    [self.view addSubview:logInButton];

}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleLightContent;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
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
    logInViewController = [[LogInViewController alloc] init];
    [self.navigationController pushViewController:logInViewController animated:YES];
    [sender setAlpha:1.0];
}

- (void)signUp:(id)sender {
    signUpWithEmailViewController = [[SignUpWithEmailViewController alloc] init];
    [self.navigationController pushViewController:signUpWithEmailViewController animated:YES];
    [sender setAlpha:1.0];
    
}

-(void)setBgColorForButton:(UIButton*)sender
{
    [sender setAlpha:0.5];
}

-(void)clearBgColorForButton:(UIButton*)sender
{
    [sender setAlpha:1.0];
}

/* ANVÄNDS EJ
-(void)doSomething:(UIButton*)sender
{
    double delayInSeconds = 0.3;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [sender setBackgroundColor:[UIColor redColor]];
    });
    //do something
    
}*/

@end
