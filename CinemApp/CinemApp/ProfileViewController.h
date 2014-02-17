//
//  ProfileViewController.h
//  CinemApp
//
//  Created by Teodor Östlund on 2014-02-13.
//
//

#import <UIKit/UIKit.h>

@interface ProfileViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *profileBackDropImage;
@property (weak, nonatomic) IBOutlet UILabel *profileNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *profilePlaceHolderImage;

@property (nonatomic) UIImage *image;
@property (nonatomic) UIImage *profilePictureImage;

@end
