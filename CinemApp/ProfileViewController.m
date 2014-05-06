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
static CGFloat backdropImageHeight  = 270.0;
static CGFloat backdropImageWidth  = 320.0;

@interface ProfileViewController ()

@end

@implementation ProfileViewController{
    UILabel *nameLabel, *noOfRatingsLabel, *ratingsLabel, *noOfFollowersLabel, *followersLabel, *noOfFollowingLabel, *followingLabel;
    UIButton *settingsButton, *followButton;
    BOOL ownUser, following;
    PFUser *thisUser;
}

@synthesize settingsView, followModel, segmentedControl, recentActivityView, highestActivityView;

-(id)initWithUser:(PFUser *)user
{
    UIImage *profileBackgroundImage;
    thisUser = user;
    self.view.backgroundColor = [UIColor colorWithRed:0.96 green:0.96 blue:0.94 alpha:1];
    
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
        [self calculateFollowers];
        ownUser = YES;
        
    }else{
        
        profileBackgroundImage = [UIImage imageNamed:@"moviebackdropplaceholder"];
        ownUser = NO;
        
        followButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        followButton.frame = CGRectMake(80, 170, 160, 28);
        [followButton.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:13.0]];
        [followButton addTarget:self action:@selector(buttonHighlighted:) forControlEvents:UIControlEventTouchDown];
        [followButton addTarget:self action:@selector(buttonPressCancelled:) forControlEvents:UIControlEventTouchDragExit];
        [followButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [followButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [[followButton layer] setBorderColor:[UIColor grayColor].CGColor];
        [[followButton layer] setBorderWidth:1.0f];
        [[followButton layer] setCornerRadius:5.0f];
        [followButton setTitle:@"Loading..." forState:UIControlStateNormal];
        
        
        dispatch_queue_t queue= dispatch_queue_create("Parse data", 0);
        dispatch_async(queue, ^{ // to get all data from server and parsing
            followModel = [[FollowModel alloc]init];
            following = [followModel isFollowing:[PFUser currentUser] :user];

            dispatch_sync(dispatch_get_main_queue(), ^{ // share data to other view controllers in main thread
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
    //Allokerar och initierar profilbilden
    UIImage *profilePictureImage = [UIImage imageNamed:@"profilePicPlaceHolder"];
    self.profilePictureImageView = [[UIImageView alloc] initWithImage:profilePictureImage];
    self.profilePictureImageView.frame = CGRectMake(120, 35, 80, 80);
    
    //Profilinfo
    nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 120, 320, 40)];
    nameLabel.text = [NSString stringWithFormat:@"%@", user.username];
    nameLabel.textAlignment = NSTextAlignmentCenter;
    nameLabel.textColor=[UIColor whiteColor];
    [nameLabel setFont:[UIFont fontWithName: @"AvenirNext-Medium" size: 25.0f]];
    
    noOfRatingsLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 210, 60, 40)];
    noOfRatingsLabel.text = [NSString stringWithFormat:@"0"];
    noOfRatingsLabel.textAlignment = NSTextAlignmentCenter;
    noOfRatingsLabel.textColor=[UIColor whiteColor];
    [noOfRatingsLabel setFont:[UIFont fontWithName: @"AvenirNext-Medium" size: 21.0f]];
    noOfRatingsLabel.alpha = 0.8;
    
    ratingsLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 230, 60, 40)];
    ratingsLabel.text = [NSString stringWithFormat:@"Ratings"];
    ratingsLabel.textAlignment = NSTextAlignmentCenter;
    ratingsLabel.textColor=[UIColor whiteColor];
    [ratingsLabel setFont:[UIFont fontWithName: @"AvenirNext-Medium" size: 12.0f]];
    ratingsLabel.alpha = 0.8;
    
    noOfFollowersLabel = [[UILabel alloc] initWithFrame:CGRectMake(125, 210, 60, 40)];
    noOfFollowersLabel.text = [NSString stringWithFormat:@"0"];
    noOfFollowersLabel.textAlignment = NSTextAlignmentCenter;
    noOfFollowersLabel.textColor=[UIColor whiteColor];
    [noOfFollowersLabel setFont:[UIFont fontWithName: @"AvenirNext-Medium" size: 21.0f]];
    noOfFollowersLabel.alpha = 0.8;
    
    followersLabel = [[UILabel alloc] initWithFrame:CGRectMake(125, 230, 60, 40)];
    followersLabel.text = [NSString stringWithFormat:@"Followers"];
    followersLabel.textAlignment = NSTextAlignmentCenter;
    followersLabel.textColor=[UIColor whiteColor];
    [followersLabel setFont:[UIFont fontWithName: @"AvenirNext-Medium" size: 12.0f]];
    followersLabel.alpha = 0.8;
    
    noOfFollowingLabel = [[UILabel alloc] initWithFrame:CGRectMake(230, 210, 60, 40)];
    noOfFollowingLabel.text = [NSString stringWithFormat:@"0"];
    noOfFollowingLabel.textAlignment = NSTextAlignmentCenter;
    noOfFollowingLabel.textColor=[UIColor whiteColor];
    [noOfFollowingLabel setFont:[UIFont fontWithName: @"AvenirNext-Medium" size: 21.0f]];
    noOfFollowingLabel.alpha = 0.8;
    
    followingLabel = [[UILabel alloc] initWithFrame:CGRectMake(230, 230, 60, 40)];
    followingLabel.text = [NSString stringWithFormat:@"Following"];
    followingLabel.textAlignment = NSTextAlignmentCenter;
    followingLabel.textColor=[UIColor whiteColor];
    [followingLabel setFont:[UIFont fontWithName: @"AvenirNext-Medium" size: 12.0f]];
    followingLabel.alpha = 0.8;
    
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
    segmentedControl = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"Most recent ratings", @"Highest ratings", nil]];
    segmentedControl.frame = CGRectMake(10, backdropImageHeight+10, 300, 29);
    segmentedControl.selectedSegmentIndex = 0;
    segmentedControl.tintColor = [UIColor colorWithRed:0.855 green:0.243 blue:0.251 alpha:1];
    [segmentedControl addTarget:self action:@selector(valueChanged:) forControlEvents: UIControlEventValueChanged];
    
    //Skapar scrollView
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.delegate = self;
    //self.scrollView.backgroundColor = [UIColor clearColor];
    self.scrollView.alwaysBounceVertical = YES;
    
    recentActivityView = [[ActivityViewController alloc]initWithUser:thisUser];
    recentActivityView.view.frame = CGRectMake(0, backdropImageHeight+20, 320, 0);
    
    
    [[recentActivityView activityTable].tableView reloadData];
    self.scrollView.contentSize = CGSizeMake(320, recentActivityView.activityTable.tableView.contentSize.height+backdropImageHeight+80);
    recentActivityView.scrollView.frame = CGRectMake(0, 0, 320, recentActivityView.activityTable.tableView.contentSize.height+backdropImageHeight);
    if(recentActivityView.scrollView.frame.size.height <= 220)//Hårdkodat utav bara helvete
        recentActivityView.scrollView.frame = CGRectMake(0, 0, 320, 0);
    
    //Lägger till alla subviews i vår vy
    [self.view addSubview:self.backdropImageView];
    [self.view addSubview:self.backdropWithBlurImageView];
    [self.scrollView addSubview:self.profilePictureImageView];
    [self.scrollView addSubview:self.recentActivityView.view];
    [self.scrollView addSubview:nameLabel];
    [self.scrollView addSubview:noOfRatingsLabel];
    [self.scrollView addSubview:ratingsLabel];
    [self.scrollView addSubview:noOfFollowersLabel];
    [self.scrollView addSubview:followersLabel];
    [self.scrollView addSubview:noOfFollowingLabel];
    [self.scrollView addSubview:followingLabel];
    [self.scrollView addSubview:settingsButton];
    [self.scrollView addSubview:followButton];
    [self.scrollView addSubview:segmentedControl];
    [self.view addSubview:self.scrollView];
    
    
    self.edgesForExtendedLayout=UIRectEdgeAll;
    self.extendedLayoutIncludesOpaqueBars=YES;
    self.automaticallyAdjustsScrollViewInsets=NO;
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
        recentActivityView.view.hidden = FALSE;
        [[recentActivityView activityTable].tableView reloadData];
        self.scrollView.contentSize = CGSizeMake(320, recentActivityView.activityTable.tableView.contentSize.height+backdropImageHeight+40);
        recentActivityView.scrollView.frame = CGRectMake(0, 0, 320, recentActivityView.activityTable.tableView.contentSize.height+backdropImageHeight);
        if(recentActivityView.scrollView.frame.size.height <= 220)//Hårdkodat utav bara helvete
            recentActivityView.scrollView.frame = CGRectMake(0, 0, 320, 0);

    }else if(segment.selectedSegmentIndex == 1){
        //visar highest
        recentActivityView.view.hidden = TRUE;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    //Tar bort "Back"-texten på filmsidorna
    self.navigationController.navigationBar.topItem.backBarButtonItem = [[UIBarButtonItem alloc]
                                                                         initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];

    if(ownUser)
        [self.navigationController setNavigationBarHidden: YES animated:YES];
    else{
        [self.navigationController setNavigationBarHidden: NO animated:YES];
        self.navigationController.navigationBar.translucent = YES;
        [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
        self.navigationController.navigationBar.shadowImage = [UIImage new];
        self.navigationController.navigationBar.barStyle = UIStatusBarStyleLightContent;
    }
    
    [self calculateFollowers];
}

- (void)viewDidAppear:(BOOL)animated {
    [recentActivityView retrieveUserRatings];
}

- (void)showSettings:(id)sender {
    
    UIImage *_defaultImage;
    [self.navigationController.navigationBar setBackgroundImage:_defaultImage forBarMetrics:UIBarMetricsDefault];

    [self.navigationController pushViewController:settingsView animated:YES];
    [self.navigationController setNavigationBarHidden: NO animated:YES];
}

- (void)followMethod:(id)sender{
    if(!following){
        following = YES;
        [followButton setTitle:@"✓ Following" forState:UIControlStateNormal];
        [followButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [[followButton layer] setBorderColor:[UIColor colorWithRed:0.580 green:0.780 blue:0.416 alpha:1].CGColor];
        followButton.backgroundColor = [UIColor colorWithRed:0.580 green:0.780 blue:0.416 alpha:1];
        followButton.tag = 1;
        dispatch_queue_t queue= dispatch_queue_create("Parse data", 0);
        dispatch_async(queue, ^{ // to get all data from server and parsing
            [followModel addFollower:[PFUser currentUser] :thisUser];
        });
    }else{
        following = NO;
        [followButton setTitle:@"+ Follow" forState:UIControlStateNormal];
        [followButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [[followButton layer] setBorderColor:[UIColor colorWithRed:0.855 green:0.243 blue:0.251 alpha:1].CGColor];
        followButton.backgroundColor = nil;
        followButton.tag = 2;
        dispatch_queue_t queue= dispatch_queue_create("Parse data", 0);
        dispatch_async(queue, ^{ // to get all data from server and parsing
            [followModel delFollower:[PFUser currentUser] :thisUser];
        });

    }
}

-(void)buttonHighlighted:(UIButton*)sender
{
    UIButton *button = (UIButton *)sender;
    if(button.tag == 1){
        [sender setAlpha:0.9];
    }else if(button.tag == 2){
        button.backgroundColor = [UIColor colorWithRed:0.855 green:0.243 blue:0.251 alpha:1];
    }
    button.frame = CGRectMake(81, 171, 158, 26);
}

-(void)buttonPressCancelled:(UIButton*)sender
{
    UIButton *button = (UIButton *)sender;
    if(button.tag == 1){
        [sender setAlpha:1.0];
    }else if(button.tag == 2){
        button.backgroundColor = nil;
    }
    button.frame = CGRectMake(80, 170, 160, 28);
}

-(void)buttonPressed:(UIButton*)sender
{
    UIButton *button = (UIButton *)sender;

    if(button.tag == 1){
        [sender setAlpha:1.0];
        noOfFollowersLabel.text = [NSString stringWithFormat:@"%i", [noOfFollowersLabel.text intValue]-1];
    }else if(button.tag == 2){
        button.backgroundColor = nil;
        noOfFollowersLabel.text = [NSString stringWithFormat:@"%i", [noOfFollowersLabel.text intValue]+1];
    }
    button.frame = CGRectMake(80, 170, 160, 28);
}

-(void)calculateFollowers{
    
    PFUser *user = thisUser;
    
    PFQuery *ratingsQuery = [PFQuery queryWithClassName:@"Rating"];
    [ratingsQuery whereKey:@"user" equalTo:user.username];
    [ratingsQuery countObjectsInBackgroundWithBlock:^(int count, NSError *error) {
        if (!error) {
            noOfRatingsLabel.text = [NSString stringWithFormat:@"%i", count];
        }
    }];
    
    PFQuery *followingQuery = [PFQuery queryWithClassName:@"Follow"];
    [followingQuery whereKey:@"userId" equalTo:user.objectId];
    [followingQuery countObjectsInBackgroundWithBlock:^(int count, NSError *error) {
        if (!error) {
            noOfFollowingLabel.text = [NSString stringWithFormat:@"%i", count];
        }
    }];
    
    PFQuery *followersQuery = [PFQuery queryWithClassName:@"Follow"];
    [followersQuery whereKey:@"followsId" equalTo:user.objectId];
    [followersQuery countObjectsInBackgroundWithBlock:^(int count, NSError *error) {
        if (!error) {
            noOfFollowersLabel.text = [NSString stringWithFormat:@"%i", count];
        }
    }];
    
    

}

@end
