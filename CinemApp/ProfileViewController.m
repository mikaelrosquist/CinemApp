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
#import <QuartzCore/QuartzCore.h>

//Sätter backgrundsbildens höjd och bredd till statiska värden
static CGFloat backdropImageHeight  = 250.0;
static CGFloat backdropImageWidth  = 320.0;

@interface ProfileViewController ()

@end

@implementation ProfileViewController{
    UILabel *nameLabel;
    UIButton *settingsButton, *followButton;
    BOOL ownUser, following;
    PFUser *thisUser;
}

@synthesize settingsView, followModel;

-(id)initWithUser:(PFUser *)user
{
    UIImage *profileBackgroundImage;
    thisUser = user;
    
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
        
        ownUser = YES;
        
    }else{
        profileBackgroundImage = [UIImage imageNamed:@"moviebackdropplaceholder"];
        ownUser = NO;
        
        followButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        followButton.frame = CGRectMake(80, 160, 160, 28);
        [followButton.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:13.0]];
        [followButton addTarget:self action:@selector(setBgColorForButton:) forControlEvents:UIControlEventTouchDown];
        [followButton addTarget:self action:@selector(clearBgColorForButton:) forControlEvents:UIControlEventTouchDragExit];
        [followButton addTarget:self action:@selector(clearBgColorForButton:) forControlEvents:UIControlEventTouchUpInside];
        
        [DejalWhiteActivityView activityViewForView:followButton withLabel:@""].showNetworkActivityIndicator = YES;
        
        dispatch_queue_t queue= dispatch_queue_create("Parse data", 0);
        dispatch_async(queue, ^{ // to get all data from server and parsing
            followModel = [[FollowModel alloc]init];
            following = [followModel isFollowing:[PFUser currentUser] :user];
            

            dispatch_sync(dispatch_get_main_queue(), ^{ // share data to other view controllers in main thread
                [DejalActivityView removeView];
                [[followButton layer] setBorderWidth:1.0f];
                [[followButton layer] setCornerRadius:5.0f];
                if(following){
                    [followButton setTitle:@"✓ Following" forState:UIControlStateNormal];
                    [followButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                    [[followButton layer] setBorderColor:[UIColor colorWithRed:0.580 green:0.780 blue:0.416 alpha:1].CGColor];
                    followButton.backgroundColor = [UIColor colorWithRed:0.580 green:0.780 blue:0.416 alpha:1];
                    [followButton addTarget:self action:@selector(followMethod:) forControlEvents:UIControlEventTouchUpInside];
                    followButton.tag = 1;

                }else{
                    [followButton setTitle:@"+ Follow" forState:UIControlStateNormal];
                    [followButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                    [[followButton layer] setBorderColor:[UIColor colorWithRed:0.855 green:0.243 blue:0.251 alpha:1].CGColor];
                    [followButton addTarget:self action:@selector(followMethod:) forControlEvents:UIControlEventTouchUpInside];
                    followButton.tag = 2;
                }
            });
        });
        
    }
    
    
    //Profilinfo
    UIImage *profilePictureImage = [UIImage imageNamed:@"profilePicPlaceHolder"];
    nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, 320, 40)];
    nameLabel.text = [NSString stringWithFormat:@"%@", user.username];
    nameLabel.textAlignment = NSTextAlignmentCenter;
    nameLabel.textColor=[UIColor whiteColor];
    [nameLabel setFont:[UIFont fontWithName: @"HelveticaNeue-Light" size: 20.0f]];
    
    //Allokerar och initierar profilbilden
    self.profilePictureImageView = [[UIImageView alloc] initWithImage:profilePictureImage];
    self.profilePictureImageView.frame = CGRectMake(120, 65, 80, 80);
    
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
    [self.scrollView addSubview:followButton];
    [self.scrollView addSubview:segmentedControl];
    [self.view addSubview:self.scrollView];
    
    self.edgesForExtendedLayout=UIRectEdgeAll;
    self.extendedLayoutIncludesOpaqueBars=YES;
    self.automaticallyAdjustsScrollViewInsets=YES;
    self.scrollView.contentSize = CGSizeMake(320, self.view.frame.size.height);
    self.scrollView.delaysContentTouches = YES;
    
    //[self setAutomaticallyAdjustsScrollViewInsets:YES];
    CGRect bounds = self.view.bounds;
    self.scrollView.frame = bounds;
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
    
    

    
    if(ownUser)
        [self.navigationController setNavigationBarHidden: YES animated:YES];
    else{
        [self.navigationController setNavigationBarHidden: NO animated:YES];
        self.navigationController.navigationBar.translucent = YES;
        [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
        self.navigationController.navigationBar.shadowImage = [UIImage new];
        self.navigationController.navigationBar.barStyle = UIStatusBarStyleLightContent;
    }
}


- (void)showSettings:(id)sender {
    
    UIImage *_defaultImage;
    [self.navigationController.navigationBar setBackgroundImage:_defaultImage forBarMetrics:UIBarMetricsDefault];

    [self.navigationController pushViewController:settingsView animated:YES];
    [self.navigationController setNavigationBarHidden: NO animated:YES];
}

- (void)followMethod:(id)sender{
    NSLog(@"%hhd", following);
    if(!following){
        [followModel addFollower:[PFUser currentUser] :thisUser];
        following = YES;
        [followButton setTitle:@"✓ Following" forState:UIControlStateNormal];
        [followButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [[followButton layer] setBorderColor:[UIColor colorWithRed:0.580 green:0.780 blue:0.416 alpha:1].CGColor];
        followButton.backgroundColor = [UIColor colorWithRed:0.580 green:0.780 blue:0.416 alpha:1];
        followButton.tag = 1;
    }else{
        [followModel delFollower:[PFUser currentUser] :thisUser];
        following = NO;
        [followButton setTitle:@"+ Follow" forState:UIControlStateNormal];
        [followButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [[followButton layer] setBorderColor:[UIColor colorWithRed:0.855 green:0.243 blue:0.251 alpha:1].CGColor];
        followButton.backgroundColor = nil;
        followButton.tag = 2;
    }
}

-(void)setBgColorForButton:(UIButton*)sender
{
    UIButton *button = (UIButton *)sender;
    if(button.tag == 1){
        [sender setAlpha:0.5];
    }else if(button.tag == 2){
        button.backgroundColor = [UIColor colorWithRed:0.855 green:0.243 blue:0.251 alpha:1];
    }
}

-(void)clearBgColorForButton:(UIButton*)sender
{
    UIButton *button = (UIButton *)sender;
    if(button.tag == 1){
        [sender setAlpha:1.0];
    }else if(button.tag == 2){
        button.backgroundColor = nil;
    }
}

@end
