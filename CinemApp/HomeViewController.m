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
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button addTarget:self
               action:@selector(aMethod:)
     forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"Show View" forState:UIControlStateNormal];
    button.frame = CGRectMake(10.0, 100.0, 300.0, 20.0);
    [self.view addSubview:button];

    
    //Nedan kod byter färg på navBar om vi vill
    //self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:1.000 green:0.314 blue:0.329 alpha:1];

}
- (void)aMethod:(UIButton*)button
{
    NSLog(@"Button  clicked.");
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
