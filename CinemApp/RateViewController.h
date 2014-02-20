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
#import "ActivityView.h"

@interface RateViewController : UIViewController<UIScrollViewDelegate>

@property (nonatomic, retain) UIScrollView *scrollView;
@property (nonatomic, retain) UIImageView *imgProfile;
@property (nonatomic, retain) UIImageView *imgWithBlur;
@property (nonatomic, retain) UIImageView *profilePictureImageView;
@property (nonatomic, strong) MovieView *movieView;
@property (nonatomic, strong) RateView *rateView;
@property (nonatomic, strong) ActivityView *activityView;


@end
