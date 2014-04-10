//
//  ProfileScrollViewController.m
//  TwProfile
//
//  Created by Edgar on 5/1/13.
//  Copyright (c) 2013 mx.com.hunk. All rights reserved.
//

#import "ProfileViewController.h"
#import "ImageEffects.h"
#import "Parse/Parse.h"

//Sätter backgrundsbildens höjd och bredd till statiska värden
static CGFloat backdropImageHeight  = 250.0;
static CGFloat backdropImageWidth  = 320.0;

@interface ProfileViewController ()

@end

@implementation ProfileViewController{
    UILabel *nameLabel;
    UIButton *settingsButton;
}

@synthesize settingsView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        settingsButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [settingsButton addTarget:self action:@selector(showSettings:) forControlEvents:UIControlEventTouchUpInside];
        settingsButton.frame = CGRectMake(283, 32, 25, 25);
        
        UIImage *settingsButtonImage = [UIImage imageNamed:@"settings_icon"];
        [settingsButton setImage:settingsButtonImage forState:UIControlStateNormal];
        settingsButton.tintColor = [UIColor whiteColor];
        [settingsButton setTitleColor:[UIColor grayColor] forState:UIControlStateSelected];


        
        //Profilinfo
        UIImage *profilePictureImage = [UIImage imageNamed:@"profilePicPlaceHolder"];
        UIImage *profileBackgroundImage = [UIImage imageNamed:@"kitten"];
        nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 23, 320, 40)];
        
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
        UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"Most recent ratings", @"Highest ratings", nil]];
        segmentedControl.frame = CGRectMake(10, backdropImageHeight+10, 300, 29);
        segmentedControl.selectedSegmentIndex = 0;
        segmentedControl.tintColor = [UIColor colorWithRed:0.855 green:0.243 blue:0.251 alpha:1];
        [segmentedControl addTarget:self action:@selector(valueChanged:) forControlEvents: UIControlEventValueChanged];
        
        //Skapar scrollView
        self.scrollView = [[UIScrollView alloc] init];
		self.scrollView.delegate = self;
        self.scrollView.backgroundColor = [UIColor clearColor];
        self.scrollView.alwaysBounceVertical = YES;
        
        //Lägger till alla subviews i vår vy
        [self.view addSubview:self.backdropImageView];
        [self.view addSubview:self.backdropWithBlurImageView];
        [self.scrollView addSubview:self.profilePictureImageView];
        [self.scrollView addSubview:nameLabel];
        [self.scrollView addSubview:settingsButton];
        [self.scrollView addSubview:segmentedControl];
        [self.view addSubview:self.scrollView];
        
        [self setAutomaticallyAdjustsScrollViewInsets:NO];
        
    }
    return self;
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

//SCROLLVIEW
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGRect f;
    CGFloat yOffset = self.scrollView.contentOffset.y;
    CGFloat enlargmentFactor = ((ABS(yOffset)+backdropImageHeight)*backdropImageWidth)/backdropImageHeight;
    float blurAlpha = (yOffset/70.0)+1.1;
    
    //Om man scrollar UP eller NER så ändras bakgrundbildens storlek och position
    if (yOffset < 0.1) {
        f = CGRectMake(-(enlargmentFactor-backdropImageWidth)/2, 0, enlargmentFactor, backdropImageHeight+ABS(yOffset));
    } else {
        f = CGRectMake(0, -yOffset, backdropImageWidth, backdropImageHeight);
    }
    
    self.backdropImageView.frame = f;
    self.backdropWithBlurImageView.frame = f;
    
    //Alpha på bakgrundsbilden och nameLabel när man scrolar
    self.backdropWithBlurImageView.alpha = blurAlpha;
    self.profilePictureImageView.alpha = blurAlpha;
    settingsButton.alpha = blurAlpha;
    nameLabel.alpha = blurAlpha;
    
    //Log för debug
    //NSLog(@"YOFFSET: %f", yOffset);
    //NSLog(@"BLUR ALPHA: %f", blurAlpha);
}

//SEGMENTED CONTROLL
- (void)valueChanged:(UISegmentedControl *)segment {
    if(segment.selectedSegmentIndex == 0) {
        //visar recent
    }else if(segment.selectedSegmentIndex == 1){
    
    }
}



- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (![PFUser currentUser]) {
        nameLabel.text = @"Laddar...";
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        [PFUser logInWithUsernameInBackground:@"admin" password:@"admin"
                                        block:^(PFUser *user, NSError *error) {
                                            if (user) {
                                                NSLog(@"Inloggning lyckades!");
                                                nameLabel.text = [NSString stringWithFormat:@"%@", user.username];
                                            } else {
                                                NSLog(@"Inloggning misslyckades!");
                                                nameLabel.text = @"nickname";
                                            }
                                        }];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    }else{
        nameLabel.text = [NSString stringWithFormat:@"%@", [PFUser currentUser].username];
    }

    //Sätter ramen för scrollView
    CGRect bounds = self.view.bounds;
    self.scrollView.frame = bounds;
    
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

-(void)showSettings:(id)sender {
    settingsView = [[SettingsRootViewController alloc] initWithStyle:UITableViewStyleGrouped];
    [self.navigationController pushViewController:settingsView animated:YES];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

@end
