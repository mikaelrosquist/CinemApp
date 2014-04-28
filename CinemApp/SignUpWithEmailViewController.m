//
//  SignUpWithEmailViewController.m
//  CinemApp
//
//  Created by Teodor Östlund on 2014-04-28.
//  Copyright (c) 2014 Rosquist Östlund. All rights reserved.
//

#import "SignUpWithEmailViewController.h"

@interface SignUpWithEmailViewController ()

@end

@implementation SignUpWithEmailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Register new account";
    [self.view setBackgroundColor:[UIColor whiteColor]];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleDefault;
    [self.navigationController setNavigationBarHidden:NO animated:YES];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
