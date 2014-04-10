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
#import "MovieTableViewController.h"

@interface RateViewController : UIViewController<UIScrollViewDelegate, UITableViewDelegate, UITextViewDelegate>

@property (nonatomic, retain) UIScrollView *scrollView;
@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) UIImageView *backdropImageView;
@property (nonatomic, retain) UIImageView *backdropWithBlurImageView;
//@property (nonatomic, strong) MovieView *movieView;
@property (nonatomic, strong) RateView *rateView;
@property (nonatomic, strong) UITableView *movieTableView; //tabellen med skådisar i movieView
//@property (nonatomic, strong) MovieTableViewController *movieTVC;

@property (nonatomic, strong) NSString *movieID;
@property (nonatomic, strong) NSString *movieName;
@property (nonatomic, strong) NSString *movieRelease;
@property (nonatomic, strong) NSString *movieGenre;
@property (nonatomic, strong) NSString *movieRuntime;
@property (nonatomic, strong) NSString *movieBackground;
@property (nonatomic, strong) NSString *moviePlot;

@property (nonatomic, strong) NSDictionary *json;
@property (nonatomic, strong) NSDictionary *creditsJson;

#pragma mark - Methods
- (void) retrieveData;

@end
