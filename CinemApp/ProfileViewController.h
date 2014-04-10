//
//  ProfileScrollViewController.h
//  TwProfile
//
//  Created by Edgar on 5/1/13.
//  Copyright (c) 2013 mx.com.hunk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MovieView.h"
#import "SettingsRootViewController.h"

@interface ProfileViewController : UIViewController<UIScrollViewDelegate>

@property (nonatomic, retain) UIScrollView *scrollView;
@property (nonatomic, retain) UIImageView *backdropImageView;
@property (nonatomic, retain) UIImageView *backdropWithBlurImageView;
@property (nonatomic, retain) UIImageView *profilePictureImageView;
@property (nonatomic, strong) SettingsRootViewController *settingsView;



@end
