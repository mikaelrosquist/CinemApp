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
#import "ActivityTableView.h"

@interface RateViewController : UIViewController<UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, retain) UIScrollView *scrollView;
@property (nonatomic, retain) UIImageView *backdropImageView;
@property (nonatomic, retain) UIImageView *backdropWithBlurImageView;
@property (nonatomic, strong) MovieView *movieView;
@property (nonatomic, strong) RateView *rateView;
@property (nonatomic, strong) ActivityTableView *activityView;


@end
