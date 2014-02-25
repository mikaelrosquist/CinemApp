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
#import "ImageEffects.h"

@interface RateViewController : UIViewController<UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, retain) UIScrollView *scrollView;
@property (nonatomic, retain) UIImageView *backdropImageView;
@property (nonatomic, retain) UIImageView *backdropWithBlurImageView;
@property (nonatomic, strong) MovieView *movieView;
@property (nonatomic, strong) RateView *rateView;
@property (nonatomic, strong) ActivityTableView *activityView;

@property (nonatomic, strong) NSString *movieID;
@property (nonatomic, strong) NSString *movieName;
@property (nonatomic, strong) NSString *movieRelease;
@property (nonatomic, strong) NSString *movieGenre;
@property (nonatomic, strong) NSString *movieRuntime;
@property (nonatomic, strong) NSString *movieBackground;

@property (nonatomic, strong) NSDictionary * json;

@end
