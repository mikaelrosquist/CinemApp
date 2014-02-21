//
//  ProfileScrollViewController.m
//  TwProfile
//
//  Created by Edgar on 5/1/13.
//  Copyright (c) 2013 mx.com.hunk. All rights reserved.
//

#import "ProfileViewController.h"
#import "ImageEffects.h"

//Sätter backgrundsbildens höjd och bredd till statiska värden
static CGFloat backdropImageHeight  = 250.0;
static CGFloat backdropImageWidth  = 320.0;

@interface ProfileViewController ()

@end

@implementation ProfileViewController{
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
        
        //Profilinfo
        nameLabel.text = @"Firstname Lastname";
        UIImage *profilePictureImage = [UIImage imageNamed:@"profilePicPlaceHolder"];
        UIImage *profileBackgroundImage = [UIImage imageNamed:@"kitten"];
        
        //Allokerar, initierar och konfiguerar profilens namn
        nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, 320, 40)];
        nameLabel.textAlignment = NSTextAlignmentCenter;
        nameLabel.textColor=[UIColor whiteColor];
        [nameLabel setFont:[UIFont fontWithName: @"HelveticaNeue-Light" size: 20.0f]];
        
        //Allokerar och initierar profilbilden
        self.profilePictureImageView = [[UIImageView alloc] initWithImage:profilePictureImage];
        self.profilePictureImageView.frame = CGRectMake(120, 75, 80, 80);
        
        //Allokerar och initierar profilens bakgrundsbild
        self.backdropImageView = [[UIImageView alloc] initWithImage:profileBackgroundImage];
		self.backdropImageView.frame = CGRectMake(0, 0, backdropImageWidth, backdropImageHeight);
        self.backdropImageView.contentMode = UIViewContentModeScaleAspectFill;
        
        //Allokerar och initierar profilens bakgrundsbild med blur
        self.backdropWithBlurImageView = [[UIImageView alloc] initWithImage:profileBackgroundImage];
		self.backdropWithBlurImageView.frame = CGRectMake(0, 0, backdropImageWidth, backdropImageHeight);
        self.backdropWithBlurImageView.contentMode = UIViewContentModeScaleAspectFill;
        self.backdropWithBlurImageView.image = [profileBackgroundImage applyDarkEffect];
        
        //Allokerar, initierar och konfiguerar segmented kontroll
        UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"Recent ratings", @"Highest ratings", nil]];
        segmentedControl.frame = CGRectMake(10, backdropImageHeight+10, 300, 29);
        segmentedControl.selectedSegmentIndex = 0;
        segmentedControl.tintColor = [UIColor colorWithRed:0.855 green:0.243 blue:0.251 alpha:1];
        [segmentedControl addTarget:self action:@selector(valueChanged:) forControlEvents: UIControlEventValueChanged];
        
        //Skapar scrollView
        self.scrollView = [[UIScrollView alloc] init];
		self.scrollView.delegate = self;
        self.scrollView.backgroundColor = [UIColor clearColor];
        self.scrollView.contentSize = CGSizeMake(320, movieView.frame.size.height+backdropImageHeight);
        self.scrollView.alwaysBounceVertical = YES;
        
        //Lägger till alla subviews i vår vy
        [self.view addSubview:self.backdropImageView];
        [self.view addSubview:self.backdropWithBlurImageView];
        [self.scrollView addSubview:self.profilePictureImageView];
        [self.scrollView addSubview:nameLabel];
        [self.scrollView addSubview:movieView];
        [self.scrollView addSubview:segmentedControl];
        [self.view addSubview:self.scrollView];
        
        [self setAutomaticallyAdjustsScrollViewInsets:NO];
        
    }
    return self;
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGRect f;
    CGFloat yOffset = self.scrollView.contentOffset.y;
    CGFloat enlargmentFactor = ((ABS(yOffset)+backdropImageHeight)*backdropImageWidth)/backdropImageHeight;
    float blurAlpha = (yOffset/70.0)+1.1;
    
    //Om man scrollar UP eller NER så ändras bakgrundbildens storlek och position
    if (yOffset < 0.1) {
        f = CGRectMake(-(enlargmentFactor-backdropImageWidth)/2, 0, enlargmentFactor, backdropImageHeight+ABS(yOffset));
        [self.navigationController setNavigationBarHidden: NO animated:YES];
    } else {
        f = CGRectMake(0, -yOffset, backdropImageWidth, backdropImageHeight);
        [self.navigationController setNavigationBarHidden: YES animated:YES];
    }
    
    self.backdropImageView.frame = f;
    self.backdropWithBlurImageView.frame = f;
    
    //Alpha på bakgrundsbilden och nameLabel när man scrolar
    self.backdropWithBlurImageView.alpha = blurAlpha;
    self.profilePictureImageView.alpha = blurAlpha;
    nameLabel.alpha = blurAlpha;
    
    //Log för debug
    NSLog(@"YOFFSET: %f", yOffset);
    NSLog(@"BLUR ALPHA: %f", blurAlpha);
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
