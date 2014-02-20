//
//  RateViewController.h
//  TabBar
//
//  Created by Teodor Östlund on 2014-02-17.
//  Copyright (c) 2014 Teodor Östlund. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RateView.h"
#import "MovieView.h"

@interface RateViewController : UIViewController<UIScrollViewDelegate>

//@property (nonatomic, strong) RateView *rv;

@property (nonatomic, retain) UIScrollView *scrollView;
@property (nonatomic, retain) UIImageView *imgProfile;
@property (nonatomic, retain) UIImageView *imgWithBlur;
@property (nonatomic, retain) UIImageView *profilePictureImageView;
@property (nonatomic, strong) MovieView *movieView;


@end
