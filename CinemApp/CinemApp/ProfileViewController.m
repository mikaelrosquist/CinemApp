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
    [PFUser logInWithUsernameInBackground:@"admin" password:@"admin"];
    
    if ([PFUser currentUser]) {
        self.profileName.text = [NSString stringWithFormat:@"%@", [[PFUser currentUser] username]];
    } else {
        self.profileName.text = NSLocalizedString(@"Not logged in", nil);
    }

    
}
- (IBAction)logOut:(id)sender {
    [PFUser logOut];
    self.profileName.text = NSLocalizedString(@"Not logged in", nil);

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end