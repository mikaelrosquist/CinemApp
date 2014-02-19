//
//  ProfileScrollViewController.m
//  TwProfile
//
//  Created by Edgar on 5/1/13.
//  Copyright (c) 2013 mx.com.hunk. All rights reserved.
//

#import "ProfileViewController.h"
#import "ImageEffects.h"

static CGFloat ImageHeight  = 250.0;
static CGFloat ImageWidth  = 320.0;

@interface ProfileViewController ()

@end

@implementation ProfileViewController{
    UIImage *image;
    UIImage *imageWithBlur;
    UIImage *profilePictureImage;
    UILabel *label;
    UIButton *settingsButton;
    TestView *tV;
}

@synthesize settingsButton;

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
        settingsButton.alpha = percent;
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
        settingsButton.alpha = 1;
        NSLog(@"YOFFSET: %f", yOffset);
    }
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"username";
        image = [UIImage imageNamed:@"kitten"];
        imageWithBlur = [UIImage imageNamed:@"kitten"];
        profilePictureImage = [UIImage imageNamed:@"profilePicPlaceHolder"];
        
        self.profilePictureImageView = [[UIImageView alloc] initWithImage:profilePictureImage];
        self.profilePictureImageView.frame = CGRectMake(120, 60, 80, 80);
        
        
        label = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, 320, 40)];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor=[UIColor whiteColor];
        label.text = @"Firstname Lastname";
        [label setFont:[UIFont fontWithName: @"HelveticaNeue-Light" size: 20.0f]];
        
        self.imgProfile = [[UIImageView alloc] initWithImage:image];
		self.imgProfile.frame = CGRectMake(0, 0, ImageWidth, ImageHeight);
        self.imgProfile.contentMode = UIViewContentModeScaleAspectFill;
        
        self.imgWithBlur = [[UIImageView alloc] initWithImage:imageWithBlur];
		self.imgWithBlur.frame = CGRectMake(0, 0, ImageWidth, ImageHeight);
        self.imgWithBlur.contentMode = UIViewContentModeScaleAspectFill;
        
        
        self.imgWithBlur.image = [image applyDarkEffect];
        
        settingsButton = [UIButton buttonWithType:UIButtonTypeCustom];
        settingsButton.frame = CGRectMake(283, 36, 25, 25);
        
        [settingsButton setBackgroundImage:[UIImage imageNamed:@"settings_icon"]forState:UIControlStateNormal];
        
        UIView *fakeView = [[UIView alloc] init];
        
        CGRect frame = fakeView.frame;
        frame.size.width = 320;
        frame.size.height = 400;
        frame.origin.y = ImageHeight;
        fakeView.frame = frame;
        
        self.scrollView = [[UIScrollView alloc] init];
		self.scrollView.delegate = self;
        self.scrollView.backgroundColor = [UIColor clearColor];
        self.scrollView.contentSize = CGSizeMake(320, frame.size.height+ImageHeight);
        
        UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"Recent ratings", @"Highest ratings", nil]];
        segmentedControl.frame = CGRectMake(10, ImageHeight+10, 300, 29);
        segmentedControl.selectedSegmentIndex = 0;
        segmentedControl.tintColor = [UIColor colorWithRed:1.000 green:0.314 blue:0.329 alpha:1];
        [segmentedControl addTarget:self action:@selector(valueChanged:) forControlEvents: UIControlEventValueChanged];
        
        [self.scrollView addSubview:fakeView];
        
        [self.view addSubview:self.imgProfile];
        [self.view addSubview:self.imgWithBlur];
        [self.scrollView addSubview:self.profilePictureImageView];
        [self.scrollView addSubview:label];
        [self.scrollView addSubview:settingsButton];
        [self.view addSubview:self.scrollView];
        [self.scrollView addSubview:tV];
        
        [self.scrollView addSubview:segmentedControl];
        
        [self setEdgesForExtendedLayout:UIRectEdgeNone];
        [self setAutomaticallyAdjustsScrollViewInsets:NO];
        
    }
    return self;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)valueChanged:(UISegmentedControl *)segment {
    
    if(segment.selectedSegmentIndex == 0) {
        tV.hidden = FALSE;
    }else if(segment.selectedSegmentIndex == 1){
        tV.hidden = TRUE;
    }else if(segment.selectedSegmentIndex == 2){
        //action for the third button (Missing)
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
    tV = [[TestView alloc]initWithFrame:CGRectMake(0, ImageHeight+10, 320, 200)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
