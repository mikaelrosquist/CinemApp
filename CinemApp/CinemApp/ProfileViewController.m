//
//  ProfileViewController.m
//  CinemApp
//
//  Created by Teodor Östlund on 2014-02-13.
//
//

#import "ProfileViewController.h"

@interface ProfileViewController ()

@end

@implementation ProfileViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.scrollView setScrollEnabled: YES];
    [self.scrollView setContentSize:CGSizeMake(320, 960)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end