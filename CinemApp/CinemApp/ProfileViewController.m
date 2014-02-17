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
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end