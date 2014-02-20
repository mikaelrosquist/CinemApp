//
//  ProfileScrollViewController.m
//  TwProfile
//
//  Created by Edgar on 5/1/13.
//  Copyright (c) 2013 mx.com.hunk. All rights reserved.
//

#import "ProfileViewController.h"
#import "ImageEffects.h"

static CGFloat backdropImageHeight  = 250.0;
static CGFloat backdropImageWidth  = 320.0;

@interface ProfileViewController ()

@end

@implementation ProfileViewController{
    UIImage *backdropImage;
    UIImage *backdropWithBlurImage;
    UILabel *nameLabel;
    MovieView *movieView;
    SettingsViewController *settingsView;
}

@synthesize movieView, settingsView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        //Allokerar och initierar movieView
        movieView = [[MovieView alloc]initWithFrame:CGRectMake(0, backdropImageHeight+10, 320, 200)];
        
        //Sätter titeln på navigationBar
        //self.title = @"username";
        
        //Laddar in bakgrundsbilden
        backdropImage = [UIImage imageNamed:@"kitten"];
        backdropWithBlurImage = [UIImage imageNamed:@"kitten"];
        
        self.profilePictureImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"profilePicPlaceHolder"]];
        self.profilePictureImageView.frame = CGRectMake(120, 75, 80, 80);
        
        nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, 320, 40)];
        nameLabel.textAlignment = NSTextAlignmentCenter;
        nameLabel.textColor=[UIColor whiteColor];
        nameLabel.text = @"Firstname Lastname";
        [nameLabel setFont:[UIFont fontWithName: @"HelveticaNeue-Light" size: 20.0f]];
        
        self.backdropImageView = [[UIImageView alloc] initWithImage:backdropImage];
		self.backdropImageView.frame = CGRectMake(0, 0, backdropImageWidth, backdropImageHeight);
        self.backdropImageView.contentMode = UIViewContentModeScaleAspectFill;
        
        self.backdropWithBlurImageView = [[UIImageView alloc] initWithImage:backdropWithBlurImage];
		self.backdropWithBlurImageView.frame = CGRectMake(0, 0, backdropImageWidth, backdropImageHeight);
        self.backdropWithBlurImageView.contentMode = UIViewContentModeScaleAspectFill;
        self.backdropWithBlurImageView.image = [backdropWithBlurImage applyDarkEffect];
        
        UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"Recent ratings", @"Highest ratings", nil]];
        segmentedControl.frame = CGRectMake(10, backdropImageHeight+10, 300, 29);
        segmentedControl.selectedSegmentIndex = 0;
        segmentedControl.tintColor = [UIColor colorWithRed:1.000 green:0.314 blue:0.329 alpha:1];
        [segmentedControl addTarget:self action:@selector(valueChanged:) forControlEvents: UIControlEventValueChanged];
        
        self.scrollView = [[UIScrollView alloc] init];
		self.scrollView.delegate = self;
        self.scrollView.backgroundColor = [UIColor clearColor];
        self.scrollView.contentSize = CGSizeMake(320, movieView.frame.size.height+backdropImageHeight);
        self.scrollView.alwaysBounceVertical = YES;
        [self.view addSubview:self.backdropImageView];
        [self.view addSubview:self.backdropWithBlurImageView];
        [self.scrollView addSubview:self.profilePictureImageView];
        [self.scrollView addSubview:nameLabel];
        [self.scrollView addSubview:movieView];
        [self.scrollView addSubview:segmentedControl];
        [self.view addSubview:self.scrollView];
        
        //Kommentera bort raden nedan om vi vill att bakgrundsbildend ska ligga nedanför navBar
        //[self setEdgesForExtendedLayout:UIRectEdgeNone];
        
        [self setAutomaticallyAdjustsScrollViewInsets:NO];
        
    }
    return self;
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat yOffset = self.scrollView.contentOffset.y;
    
    if (yOffset < 0.1) {
        //Beräknar storleken på bakgrundsbilden medan man scrollar NER
        CGFloat enlargmentFactor = ((ABS(yOffset)+backdropImageHeight)*backdropImageWidth)/backdropImageHeight;
        CGRect f = CGRectMake(-(enlargmentFactor-backdropImageWidth)/2, 0, enlargmentFactor, backdropImageHeight+ABS(yOffset));
        self.backdropImageView.frame = f;
        self.backdropWithBlurImageView.frame = f;
        
        //Alpha på bakgrundsbilden, profilbilden och nameLabel när man scrollar NER
        float blurAlpha = (yOffset/70.0)+1.1;
        self.backdropWithBlurImageView.alpha = blurAlpha;
        self.profilePictureImageView.alpha = blurAlpha;
        nameLabel.alpha = blurAlpha;
        
        NSLog(@"YOFFSET: %f", yOffset);
        NSLog(@"BLUR ALPHA: %f", blurAlpha);

        //Visar "Settings"-knappen när man scrollar NER
        [self.navigationController setNavigationBarHidden: NO animated:YES];
        
    } else {
        //Beräknar storleken på bakgrundsbilden medan man scrollar UPP
        CGRect f = CGRectMake(0, -yOffset, backdropImageWidth, backdropImageHeight);
        self.backdropImageView.frame = f;
        self.backdropWithBlurImageView.frame = f;
        
        //Alpha på bakgrundsbilden när man scrollar UPP
        self.backdropWithBlurImageView.alpha = 1;
        self.profilePictureImageView.alpha = 1;

        NSLog(@"YOFFSET: %f", yOffset);
        
        //Gömmer "Settings"-knappen när man scrollar UPP
        [self.navigationController setNavigationBarHidden: YES animated:YES];
    
    }
    
}

- (void)valueChanged:(UISegmentedControl *)segment {
    if(segment.selectedSegmentIndex == 0) {
        movieView.hidden = FALSE;
    }else if(segment.selectedSegmentIndex == 1){
        movieView.hidden = TRUE;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    //Sätter ramen för scrollView
    CGRect bounds = self.view.bounds;
    self.scrollView.frame = bounds;
    
    //Sätter statusbar till VIT
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIBarButtonItem *settingsButton = [[UIBarButtonItem alloc]
                                     initWithImage:[[UIImage imageNamed:@"settings_icon"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                       style:UIBarButtonItemStyleBordered
                                       target:self
                                       action:@selector(pushMyNewViewController:)];
    
    //Lägger till "Settings"-knapp i navigationBar
    self.navigationItem.rightBarButtonItem = settingsButton;
    settingsView = [[SettingsViewController alloc] init];
}

-(void)pushMyNewViewController:(id)sender {
    [self.navigationController pushViewController:settingsView animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
