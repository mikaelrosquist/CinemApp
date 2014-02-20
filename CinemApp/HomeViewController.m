//
//  HomeViewController.m
//  TabBar
//
//  Created by Teodor Östlund on 2014-02-17.
//  Copyright (c) 2014 Teodor Östlund. All rights reserved.
//

#import "HomeViewController.h"

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
    
    //Byter färg på navigationBar
    //self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:1.000 green:0.314 blue:0.329 alpha:1];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
