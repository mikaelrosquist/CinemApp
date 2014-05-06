//
//  NotificationViewController.m
//  TabBar
//
//  Created by Teodor Östlund on 2014-02-17.
//  Copyright (c) 2014 Teodor Östlund. All rights reserved.
//

#import "NotificationViewController.h"
#import "AppDelegate.h"


@interface NotificationViewController ()

@end

@implementation NotificationViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"Notifications";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    UILabel *underConstruction;
    underConstruction = [[UILabel alloc] initWithFrame:CGRectMake(0, 120, 320, 40)];
    underConstruction.text = @"This function is under construction";
    underConstruction.textAlignment = NSTextAlignmentCenter;
    underConstruction.textColor=[UIColor lightGrayColor];
    [underConstruction setFont:[UIFont fontWithName: @"AvenirNext-Medium" size: 14.0f]];
    [self.view addSubview:underConstruction];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [[[[[self tabBarController] tabBar] items]
      objectAtIndex:3] setBadgeValue:nil];
    
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    app.badge = 0;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end