//
//  RateViewController.m
//  TabBar
//
//  Created by Teodor Östlund on 2014-02-17.
//  Copyright (c) 2014 Teodor Östlund. All rights reserved.
//

#import "RateViewController.h"
#import "ImageEffects.h"

static CGFloat ImageHeight  = 200.0;
static CGFloat ImageWidth  = 320.0;

@interface RateViewController ()

@end

@implementation RateViewController{
    UIImage *image, *imageWithBlur, *profilePictureImage;
    UILabel *movieTitleLabel, *movieReleaseLabel;
}

@synthesize movieView, rateView, activityView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        movieView = [[MovieView alloc]initWithFrame:CGRectMake(0, ImageHeight+10, 320, 200)];
        rateView = [[RateView alloc]initWithFrame:CGRectMake(0, ImageHeight+10, 320, 400)];
        activityView = [[ActivityView alloc]initWithFrame:CGRectMake(0, ImageHeight+10, 320, 200)];
        
        self.title = @"";
        
        image = [UIImage imageNamed:@"drstrangelove"];
        imageWithBlur = [UIImage imageNamed:@"drstrangelove"];
        
        NSString *movieTitle = @"Dr. Strangelove or: How I Learned to Stop Worrying and Love the Bomb";
        NSString *movieRelease = @"(1964)";
        
        movieTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 115, 310, 60)];
        movieTitleLabel.text = [NSString stringWithFormat:@"%@ %@", movieTitle, movieRelease];
        movieTitleLabel.textColor=[UIColor whiteColor];
        movieTitleLabel.numberOfLines = 0;
        movieTitleLabel.textAlignment = NSTextAlignmentLeft;
        movieTitleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        [movieTitleLabel setFont:[UIFont fontWithName: @"HelveticaNeue-Light" size: 22.0]];
        [movieTitleLabel sizeToFit];
        
        NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithAttributedString: movieTitleLabel.attributedText];
        [text addAttribute: NSForegroundColorAttributeName value: [UIColor grayColor] range: NSMakeRange([movieTitle length]+1, 6)];
        [text addAttribute: NSFontAttributeName value: [UIFont fontWithName: @"HelveticaNeue-Light" size: 16.0] range: NSMakeRange([movieTitle length]+1, 6)];
        [movieTitleLabel setAttributedText: text];
        
        self.imgProfile = [[UIImageView alloc] initWithImage:image];
		self.imgProfile.frame = CGRectMake(0, 0, ImageWidth, ImageHeight);
        self.imgProfile.contentMode = UIViewContentModeScaleAspectFill;
        
        self.imgWithBlur = [[UIImageView alloc] initWithImage:imageWithBlur];
		self.imgWithBlur.frame = CGRectMake(0, 0, ImageWidth, ImageHeight);
        self.imgWithBlur.contentMode = UIViewContentModeScaleAspectFill;
        
        self.imgWithBlur.image = [image applyDarkEffectWithIntensity:0 darkness:0.5];
        
        UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"Information", @"Rate", @"Activity", nil]];
        segmentedControl.frame = CGRectMake(10, ImageHeight+10, 300, 29);
        segmentedControl.selectedSegmentIndex = 0;
        segmentedControl.tintColor = [UIColor colorWithRed:1.000 green:0.314 blue:0.329 alpha:1];
        [segmentedControl addTarget:self action:@selector(valueChanged:) forControlEvents: UIControlEventValueChanged];
        
        self.scrollView = [[UIScrollView alloc] init];
		self.scrollView.delegate = self;
        self.scrollView.backgroundColor = [UIColor clearColor];
        self.scrollView.contentSize = CGSizeMake(320, movieView.frame.size.height+ImageHeight);
        self.scrollView.alwaysBounceVertical = YES;
        
        [self.view addSubview:self.imgProfile];
        [self.view addSubview:self.imgWithBlur];
        [self.scrollView addSubview:movieTitleLabel];
        [self.scrollView addSubview:movieReleaseLabel];
        [self.scrollView addSubview:movieView];
        [self.scrollView addSubview:rateView];
        [self.scrollView addSubview:activityView];
        [self.scrollView addSubview:segmentedControl];
        [self.view addSubview:self.scrollView];
        
        //Ska göra det enklare att använda slidern, vet ej om det funkar
        self.scrollView.canCancelContentTouches = YES;
        self.scrollView.delaysContentTouches = YES;
        
        //Kommentera bort raden nedan om vi vill att bakgrundsbildend ska ligga nedanför navBar
        //[self setEdgesForExtendedLayout:UIRectEdgeNone];
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
        movieTitleLabel.alpha = percent;
        NSLog(@"YOFFSET: %f", yOffset);
        NSLog(@"BLUR ALPHA: %f", percent);
        
    } else {
        
        CGRect f = CGRectMake(0, -yOffset, ImageWidth, ImageHeight);

        self.imgProfile.frame = f;
        self.imgWithBlur.frame = f;
        
        self.imgWithBlur.alpha = 1;
        self.profilePictureImageView.alpha = 1;
        movieTitleLabel.alpha = 1;
        NSLog(@"YOFFSET: %f", yOffset);
    }
}

- (void)valueChanged:(UISegmentedControl *)segment {
    
    if(segment.selectedSegmentIndex == 0) {
        movieView.hidden = FALSE;
        rateView.hidden = TRUE;
        activityView.hidden = TRUE;
        self.scrollView.contentSize = CGSizeMake(320, movieView.frame.size.height+ImageHeight);
    }else if(segment.selectedSegmentIndex == 1){
        movieView.hidden = TRUE;
        rateView.hidden = FALSE;
        activityView.hidden = TRUE;
        self.scrollView.contentSize = CGSizeMake(320, rateView.frame.size.height+ImageHeight);
    }else if(segment.selectedSegmentIndex == 2){
        movieView.hidden = TRUE;
        rateView.hidden = TRUE;
        activityView.hidden = FALSE;
        self.scrollView.contentSize = CGSizeMake(320, activityView.frame.size.height+ImageHeight);
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
    
    rateView.hidden = TRUE;
    activityView.hidden = TRUE;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
