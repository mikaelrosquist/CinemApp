//
//  ProfileView.h
//  CinemApp
//
//  Created by Teodor Östlund on 2014-02-18.
//  Copyright (c) 2014 Rosquist Östlund. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProfileView : UIView<UIScrollViewDelegate>

@property (nonatomic, retain) UIScrollView *scrollView;
@property (nonatomic, retain) UIImageView *imgProfile;
@property (nonatomic, retain) UIImageView *imgWithBlur;
@property (nonatomic, retain) UIImageView *profilePictureImageView;

@end
