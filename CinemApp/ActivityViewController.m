//
//  ActivityViewController.m
//  TabBar
//
//  Created by Teodor Östlund on 2014-02-17.
//  Copyright (c) 2014 Teodor Östlund. All rights reserved.
//

#import "ActivityViewController.h"

@interface ActivityViewController ()

@end

@implementation ActivityViewController

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end