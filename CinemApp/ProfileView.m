//
//  ProfileView.m
//  CinemApp
//
//  Created by Teodor Östlund on 2014-02-18.
//  Copyright (c) 2014 Rosquist Östlund. All rights reserved.
//

#import "ProfileView.h"
#import "ImageEffects.h"

static CGFloat ImageHeight  = 280.0;
static CGFloat ImageWidth  = 320.0;

@implementation ProfileView{
    UIImage *image;
    UIImage *imageWithBlur;
    UIImage *profilePictureImage;
    UILabel *label;
}
/*
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        image = [UIImage imageNamed:@"kitten"];
        imageWithBlur = [UIImage imageNamed:@"kitten"];
        profilePictureImage = [UIImage imageNamed:@"profilePicPlaceHolder"];
        
        self.profilePictureImageView = [[UIImageView alloc] initWithImage:profilePictureImage];
        self.profilePictureImageView.frame = CGRectMake(120, 80, 80, 80);
        
        
        label = [[UILabel alloc] initWithFrame:CGRectMake(0, 30, 320, 40)];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor=[UIColor blackColor];
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
        
        [self addSubview:self.imgProfile];
        [self addSubview:self.imgWithBlur];
        [self addSubview:self.profilePictureImageView];
        [self addSubview:label];
        [self addSubview:self.scrollView];
        
        [self.scrollView addSubview:segmentedControl];
    }
    return self;
}
*/
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        // initilize all your UIView components
        UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(20,30, 200, 44)];
        label1.text = @"i am label 1";
        [self addSubview:label1]; //add label1 to your custom view
        
        UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake(20,80, 200, 44)];
        label2.text = @"i am label 2";
        [self addSubview:label2]; //add label2 to your custom view
        
}
    return self;
}

@end
