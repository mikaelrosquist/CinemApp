//
//  ProfileViewController.m
//  CinemApp
//
//  Created by Teodor Östlund on 2014-02-13.
//
//

#import "ProfileViewController.h"
#import "UIImage+ImageEffects.h"

@interface ProfileViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *profileBackDropImage;
@property (weak, nonatomic) IBOutlet UILabel *profileNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *profilePlaceHolderImage;

@property (nonatomic) UIImage *image;
@property (nonatomic) UIImage *profilePictureImage;

@end

@implementation ProfileViewController

@synthesize profilePictureImage;

- (void)viewDidLoad
{
    [super viewDidLoad];
   
    self.image = [UIImage imageNamed:@"kitten"];
    self.profilePictureImage = [UIImage imageNamed:@"profilePlaceHolder"];

    NSString *name = @"Firstname Lastname";
    UIImage *effectImage = [self.image applyDarkEffect];

    self.profileNameLabel.textColor = [UIColor whiteColor];

    self.profileBackDropImage.image = effectImage;
    self.profilePlaceHolderImage.image = profilePictureImage;
    self.profileNameLabel.text = name;
    
/*
 //TEST LOGIN
    [PFUser logInWithUsername:@"admin" password:@"admin"];
    
    if ([PFUser currentUser]) {
        self.profileName.text = [NSString stringWithFormat:@"%@", [[PFUser currentUser] username]];
    } else {
        self.profileName.text = @"Not logged in";
    }
*/
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end