//
//  ProfileScrollViewController.m
//  TwProfile
//
//  Created by Edgar on 5/1/13.
//  Copyright (c) 2013 mx.com.hunk. All rights reserved.
//

#import "ProfileViewController.h"
#import "ImageEffects.h"

static CGFloat ImageHeight  = 280.0;
static CGFloat ImageWidth  = 320.0;

@interface ProfileViewController ()
    
@end

@implementation ProfileViewController{
    UIImage *image;
    UIImage *imageWithBlur;
    UIImage *profilePictureImage;
    UILabel *label;
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
    CGRect p = self.profilePictureImageView.frame;
    
    p.origin.y = 80-yOffset;
    self.profilePictureImageView.frame = p;
    CGRect l = label.frame;
    l.origin.y = 30-yOffset;
    label.frame = l;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        image = [UIImage imageNamed:@"kitten"];
        imageWithBlur = [UIImage imageNamed:@"kitten"];
        profilePictureImage = [UIImage imageNamed:@"profilePicPlaceHolder"];
        
        self.profilePictureImageView = [[UIImageView alloc] initWithImage:profilePictureImage];
        self.profilePictureImageView.frame = CGRectMake(120, 80, 80, 80);
        
        
        label = [[UILabel alloc] initWithFrame:CGRectMake(0, 30, 320, 40)];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor=[UIColor whiteColor];
        label.text = @"Firstname Lastname";
        [label setFont:[UIFont fontWithName: @"HelveticaNeue-Thin" size: 20.0f]];
        
        self.imgProfile = [[UIImageView alloc] initWithImage:image];
		self.imgProfile.frame = CGRectMake(0, 0, ImageWidth, ImageHeight);
        self.imgProfile.contentMode = UIViewContentModeScaleAspectFill;
        
        self.imgWithBlur = [[UIImageView alloc] initWithImage:imageWithBlur];
		self.imgWithBlur.frame = CGRectMake(0, 0, ImageWidth, ImageHeight);
        self.imgWithBlur.contentMode = UIViewContentModeScaleAspectFill;
        
        
        self.imgWithBlur.image = [image applyBlurWithRadius:30 tintColor:[UIColor colorWithWhite:1.0 alpha:0.3] saturationDeltaFactor:1.8 maskImage:nil];
        
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
        segmentedControl.frame = CGRectMake(10, 290, 300, 29);
        segmentedControl.selectedSegmentIndex = 0;
        segmentedControl.tintColor = [UIColor colorWithRed:1.000 green:0.314 blue:0.329 alpha:1];
        [segmentedControl addTarget:self action:@selector(valueChanged:) forControlEvents: UIControlEventValueChanged];
        
        [self.scrollView addSubview:fakeView];
        
        [self.view addSubview:self.imgProfile];
        [self.view addSubview:self.imgWithBlur];
        [self.view addSubview:self.profilePictureImageView];
        [self.view addSubview:label];
        [self.view addSubview:self.scrollView];
        
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
        //action for the first button (All)
    }else if(segment.selectedSegmentIndex == 1){
        //action for the second button (Present)
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
    // Do any additional setup after loading the view, typically from a nib.
    //create your view where u want
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
