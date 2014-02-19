//
//  ProfileScrollViewController.h
//  TwProfile
//
//  Created by Edgar on 5/1/13.
//  Copyright (c) 2013 mx.com.hunk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TestView.h"

@interface ProfileViewController : UIViewController<UIScrollViewDelegate>

@property (nonatomic, retain) UIScrollView *scrollView;
@property (nonatomic, retain) UIImageView *imgProfile;
@property (nonatomic, retain) UIImageView *imgWithBlur;
@property (nonatomic, retain) UIImageView *profilePictureImageView;
@property (nonatomic, strong) UIButton *settingsButton;
@property (nonatomic, strong) TestView *tV;

@end
