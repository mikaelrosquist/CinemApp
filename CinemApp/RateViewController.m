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
    UILabel *movieTitleLabel, *movieGenresLabel, *movieRuntimeLabel;
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
        
        image = [UIImage imageNamed:@"movie"];
        imageWithBlur = [UIImage imageNamed:@"movie"];
        
        NSString *movieTitle = @"Jurassic Park";
        NSString *movieRelease = @"(1994)";
        NSString *movieGenres = @"Adventure, Sci-Fi";
        NSString *movieRuntime = @"127 min";
        
        //Om titeln är för lång så kortas den ned
        if (movieTitle.length > 65) {
            movieTitle = [[movieTitle substringToIndex:65] stringByAppendingString:@"..."];
        }
        
        movieTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 140, 300, 60)];
        
        //stringByPaddingToLength nedan utökar strängen så att den alltid är 100 tecken, annars hamnar texten på olika ställen beroende på längden på titeln.
        movieTitleLabel.text = [[NSString stringWithFormat:@"%@ %@ ", movieTitle, movieRelease] stringByPaddingToLength: 100 withString: @"  " startingAtIndex:0];
        movieTitleLabel.textColor=[UIColor whiteColor];
        movieTitleLabel.numberOfLines = 3;
        movieTitleLabel.textAlignment = NSTextAlignmentLeft;
        movieTitleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        [movieTitleLabel setFont:[UIFont fontWithName: @"HelveticaNeue-Light" size: 22.0]];
        [movieTitleLabel sizeToFit];
        
        //Flyttar movieTitleLabel beroende på hur hög den är (alltså hur många rader), eftersom vi vill få plats med runtime och annat under.
        movieTitleLabel.frame = CGRectMake(10, 140-movieTitleLabel.frame.size.height+20, 300, movieTitleLabel.frame.size.height);

        NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithAttributedString: movieTitleLabel.attributedText];
        [text addAttribute: NSForegroundColorAttributeName value: [UIColor lightGrayColor] range: NSMakeRange([movieTitle length]+1, 6)];
        [text addAttribute: NSFontAttributeName value: [UIFont fontWithName: @"HelveticaNeue-Light" size: 16.0] range: NSMakeRange([movieTitle length]+1, 6)];
        [movieTitleLabel setAttributedText: text];
        
        movieGenresLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, movieTitleLabel.frame.origin.y+movieTitleLabel.frame.size.height+3, 140, 20)];
        movieGenresLabel.text = movieGenres;
        movieGenresLabel.textColor=[UIColor lightGrayColor];
        movieGenresLabel.textAlignment = NSTextAlignmentLeft;
        [movieGenresLabel setFont:[UIFont fontWithName: @"HelveticaNeue-Light" size: 11.0]];
        [movieGenresLabel sizeToFit];
        
        movieRuntimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, movieGenresLabel.frame.origin.y+movieGenresLabel.frame.size.height+3, 140, 20)];
        movieRuntimeLabel.text = movieRuntime;
        movieRuntimeLabel.textColor=[UIColor lightGrayColor];
        movieRuntimeLabel.textAlignment = NSTextAlignmentLeft;
        [movieRuntimeLabel setFont:[UIFont fontWithName: @"HelveticaNeue-Light" size: 11.0]];
        [movieRuntimeLabel sizeToFit];
        
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
        segmentedControl.tintColor = [UIColor colorWithRed:0.855 green:0.243 blue:0.251 alpha:1];
        [segmentedControl addTarget:self action:@selector(valueChanged:) forControlEvents: UIControlEventValueChanged];
        
        self.scrollView = [[UIScrollView alloc] init];
		self.scrollView.delegate = self;
        self.scrollView.backgroundColor = [UIColor clearColor];
        self.scrollView.contentSize = CGSizeMake(320, movieView.frame.size.height+ImageHeight);
        self.scrollView.alwaysBounceVertical = YES;
        
        [self.view addSubview:self.imgProfile];
        [self.view addSubview:self.imgWithBlur];
        [self.scrollView addSubview:movieTitleLabel];
        [self.scrollView addSubview:movieGenresLabel];
        [self.scrollView addSubview:movieRuntimeLabel];
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
        movieRuntimeLabel.alpha = percent;
        movieGenresLabel.alpha = percent;
        NSLog(@"YOFFSET: %f", yOffset);
        NSLog(@"BLUR ALPHA: %f", percent);
        
    } else {
        
        CGRect f = CGRectMake(0, -yOffset, ImageWidth, ImageHeight);

        self.imgProfile.frame = f;
        self.imgWithBlur.frame = f;
        
        self.imgWithBlur.alpha = 1;
        self.profilePictureImageView.alpha = 1;
        movieTitleLabel.alpha = 1;
        movieGenresLabel.alpha = 1;
        movieRuntimeLabel.alpha = 1;
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
