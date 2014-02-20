//
//  RateViewController.m
//  TabBar
//
//  Created by Teodor Östlund on 2014-02-17.
//  Copyright (c) 2014 Teodor Östlund. All rights reserved.
//

#import "RateViewController.h"
#import "ImageEffects.h"

static CGFloat ImageHeight  = 250.0;
static CGFloat ImageWidth  = 320.0;

@interface RateViewController ()

@end

@implementation RateViewController{
    UIImage *image;
    UIImage *imageWithBlur;
    UIImage *profilePictureImage;
    UILabel *label;
}

@synthesize movieView = _movieView;
@synthesize rateView = _rateView;
@synthesize activityView = _activityView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        _movieView = [[MovieView alloc]initWithFrame:CGRectMake(0, ImageHeight+10, 320, 200)];
        _rateView = [[RateView alloc]initWithFrame:CGRectMake(0, ImageHeight+10, 320, 400)];
        _activityView = [[ActivityView alloc]initWithFrame:CGRectMake(0, ImageHeight+10, 320, 200)];
        
        self.title = @"Movie";
        
        image = [UIImage imageNamed:@"kitten"];
        imageWithBlur = [UIImage imageNamed:@"kitten"];
        profilePictureImage = [UIImage imageNamed:@"profilePicPlaceHolder"];
        
        self.profilePictureImageView = [[UIImageView alloc] initWithImage:profilePictureImage];
        self.profilePictureImageView.frame = CGRectMake(120, 60, 80, 80);
        
        label = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, 320, 40)];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor=[UIColor whiteColor];
        label.text = @"Movie Title";
        [label setFont:[UIFont fontWithName: @"HelveticaNeue-Light" size: 20.0f]];
        
        self.imgProfile = [[UIImageView alloc] initWithImage:image];
		self.imgProfile.frame = CGRectMake(0, 0, ImageWidth, ImageHeight);
        self.imgProfile.contentMode = UIViewContentModeScaleAspectFill;
        
        self.imgWithBlur = [[UIImageView alloc] initWithImage:imageWithBlur];
		self.imgWithBlur.frame = CGRectMake(0, 0, ImageWidth, ImageHeight);
        self.imgWithBlur.contentMode = UIViewContentModeScaleAspectFill;
        
        self.imgWithBlur.image = [image applyDarkEffect];
        
        UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"Information", @"Rate", @"Activity", nil]];
        segmentedControl.frame = CGRectMake(10, ImageHeight+10, 300, 29);
        segmentedControl.selectedSegmentIndex = 0;
        segmentedControl.tintColor = [UIColor colorWithRed:1.000 green:0.314 blue:0.329 alpha:1];
        [segmentedControl addTarget:self action:@selector(valueChanged:) forControlEvents: UIControlEventValueChanged];
        
        self.scrollView = [[UIScrollView alloc] init];
		self.scrollView.delegate = self;
        self.scrollView.backgroundColor = [UIColor clearColor];
        self.scrollView.contentSize = CGSizeMake(320, _movieView.frame.size.height+ImageHeight);
        self.scrollView.alwaysBounceVertical = YES;
        
        [self.view addSubview:self.imgProfile];
        [self.view addSubview:self.imgWithBlur];
        [self.scrollView addSubview:self.profilePictureImageView];
        [self.view addSubview:label];
        [self.scrollView addSubview:_movieView];
        [self.scrollView addSubview:_rateView];
        [self.scrollView addSubview:_activityView];
        [self.scrollView addSubview:segmentedControl];
        [self.view addSubview:self.scrollView];
        
        [self setEdgesForExtendedLayout:UIRectEdgeNone];
        [self setAutomaticallyAdjustsScrollViewInsets:NO];

        
    }
    return self;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat yOffset = self.scrollView.contentOffset.y;
    
    if (yOffset < 0) {
        CGFloat factor = ((ABS(yOffset)+ImageHeight)*ImageWidth)/ImageHeight;
        CGRect f = CGRectMake(-(factor-ImageWidth)/2, 0, factor, ImageHeight+ABS(yOffset));
        self.imgProfile.frame = f;
        self.imgWithBlur.frame = f;
        float percent = (yOffset/70.0)+1.1;
        self.imgWithBlur.alpha = percent;
        self.profilePictureImageView.alpha = percent;
        label.alpha = percent;
        NSLog(@"YOFFSET: %f", yOffset);
        NSLog(@"BLUR ALPHA: %f", percent);
        
    } else {
        CGRect f = self.imgProfile.frame;
        f.origin.y = -yOffset;
        
        self.imgProfile.frame = f;
        self.imgWithBlur.frame = f;
        
        self.imgWithBlur.alpha = 1;
        self.profilePictureImageView.alpha = 1;
        label.alpha = 1;
        NSLog(@"YOFFSET: %f", yOffset);
    }
}

- (void)valueChanged:(UISegmentedControl *)segment {
    
    if(segment.selectedSegmentIndex == 0) {
        _movieView.hidden = FALSE;
        _rateView.hidden = TRUE;
        _activityView.hidden = TRUE;
        self.scrollView.contentSize = CGSizeMake(320, _movieView.frame.size.height+ImageHeight);
    }else if(segment.selectedSegmentIndex == 1){
        _movieView.hidden = TRUE;
        _rateView.hidden = FALSE;
        _activityView.hidden = TRUE;
        self.scrollView.contentSize = CGSizeMake(320, _rateView.frame.size.height+ImageHeight);
    }else if(segment.selectedSegmentIndex == 2){
        _movieView.hidden = TRUE;
        _rateView.hidden = TRUE;
        _activityView.hidden = FALSE;
        self.scrollView.contentSize = CGSizeMake(320, _activityView.frame.size.height+ImageHeight);
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    CGRect bounds = self.view.bounds;
    self.scrollView.frame = bounds;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _rateView.hidden = TRUE;
    _activityView.hidden = TRUE;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)buttonPressed{
    NSLog(@"button pressed");
    //label.text = @"Button pressed";
}

@end
