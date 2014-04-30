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
#import "DejalActivityView.h"

//Sätter backgrundsbildens höjd och bredd till statiska värden
static CGFloat backdropImageHeight  = 250.0;
static CGFloat backdropImageWidth  = 320.0;

@interface ProfileViewController ()

@end

@implementation ProfileViewController{
    UILabel *nameLabel;
    UIButton *settingsButton;
    BOOL ownUser;
}

@synthesize settingsView;

-(id)initWithUser:(PFUser *)user
{
    NSLog(@"LADDAT %@:s PROFIL", user.username);
    self.view.backgroundColor = [UIColor colorWithRed:0.96 green:0.96 blue:0.94 alpha:1];
    [DejalActivityView activityViewForView:self.view].showNetworkActivityIndicator = YES;
    
    UIImage *profileBackgroundImage;
    
    if(user == [PFUser currentUser]){
        settingsButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [settingsButton addTarget:self action:@selector(showSettings:) forControlEvents:UIControlEventTouchUpInside];
        settingsButton.frame = CGRectMake(276, 25, 35, 35);
        
        UIImage *settingsButtonImage = [UIImage imageNamed:@"settings_icon"];
        [settingsButton setImage:settingsButtonImage forState:UIControlStateNormal];
        settingsButton.tintColor = [UIColor whiteColor];
        [settingsButton setTitleColor:[UIColor grayColor] forState:UIControlStateSelected];
        settingsView = [[SettingsRootViewController alloc] initWithStyle:UITableViewStyleGrouped];
        profileBackgroundImage = [UIImage imageNamed:@"kitten"];
        [self.navigationController setNavigationBarHidden: YES animated:NO];
        
        ownUser = YES;
        
    }else{
        profileBackgroundImage = [UIImage imageNamed:@"moviebackdropplaceholder"];
        ownUser = NO;
    }
    
    
    //Profilinfo
    UIImage *profilePictureImage = [UIImage imageNamed:@"profilePicPlaceHolder"];
    nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 23, 320, 40)];
    nameLabel.text = [NSString stringWithFormat:@"%@", user.username];
    nameLabel.textAlignment = NSTextAlignmentCenter;
    nameLabel.textColor=[UIColor whiteColor];
    [nameLabel setFont:[UIFont fontWithName: @"HelveticaNeue-Light" size: 20.0f]];
    
    //Allokerar och initierar profilbilden
    self.profilePictureImageView = [[UIImageView alloc] initWithImage:profilePictureImage];
    self.profilePictureImageView.frame = CGRectMake(120, 75, 80, 80);
    
    //Allokerar och initierar profilens bakgrundsbild
    self.backdropImageView = [[UIImageView alloc] initWithImage:profileBackgroundImage];
    self.backdropImageView.backgroundColor = [UIColor darkGrayColor];
    self.backdropImageView.frame = CGRectMake(0, 0, backdropImageWidth, backdropImageHeight);
    self.backdropImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.backdropImageView setClipsToBounds:YES];
    
    //Allokerar och initierar profilens bakgrundsbild med blur
    self.backdropWithBlurImageView = [[UIImageView alloc] initWithImage:profileBackgroundImage];
    self.backdropWithBlurImageView.frame = CGRectMake(0, 0, backdropImageWidth, backdropImageHeight);
    self.backdropWithBlurImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.backdropWithBlurImageView.image = [profileBackgroundImage applyDarkEffect];
    [self.backdropWithBlurImageView setClipsToBounds:YES];
    
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
    
    self.edgesForExtendedLayout=UIRectEdgeAll;
    self.extendedLayoutIncludesOpaqueBars=YES;
    self.automaticallyAdjustsScrollViewInsets=YES;
    self.scrollView.contentSize = CGSizeMake(320, self.view.frame.size.height);
    
    //[self setAutomaticallyAdjustsScrollViewInsets:YES];
    CGRect bounds = self.view.bounds;
    self.scrollView.frame = bounds;
    [DejalActivityView removeView];
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

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    //Sätter ramen för scrollView
    CGRect bounds = self.view.bounds;
    self.scrollView.frame = bounds;
    
    if(ownUser)
        [self.navigationController setNavigationBarHidden: YES animated:NO];
    else{
        [self.navigationController.navigationBar setTintColor:[UIColor colorWithRed:0.855 green:0.243 blue:0.251 alpha:1]];
        self.navigationController.navigationBar.translucent = YES;
        [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
        self.navigationController.navigationBar.shadowImage = [UIImage new];
        self.navigationController.navigationBar.barStyle = UIStatusBarStyleLightContent;
        [self.navigationController setNavigationBarHidden: NO animated:NO];
    }
    
}

-(void)showSettings:(id)sender {
    
    UIImage *_defaultImage;
    [self.navigationController.navigationBar setBackgroundImage:_defaultImage forBarMetrics:UIBarMetricsDefault];

    [self.navigationController pushViewController:settingsView animated:YES];
    [self.navigationController setNavigationBarHidden: NO animated:YES];

}

@end
