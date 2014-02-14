//
//  ProfileViewController.m
//  CinemApp
//
//  Created by Teodor Östlund on 2014-02-13.
//
//

#import "ProfileViewController.h"
#import <Parse/Parse.h>

@interface ProfileViewController ()

@end

@implementation ProfileViewController
@synthesize profileName;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [PFUser logInWithUsername:@"admin" password:@"admin"];
    
    if ([PFUser currentUser]) {
        self.profileName.text = [NSString stringWithFormat:@"%@", [[PFUser currentUser] username]];
    } else {
        self.profileName.text = @"Not logged in";
    }

    
}
- (IBAction)logOut:(id)sender {
    [PFUser logOut];
    self.profileName.text = @"Not logged in";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end