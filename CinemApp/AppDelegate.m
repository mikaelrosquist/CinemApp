//
//  AppDelegate.m
//  CinemApp
//
//  Created by Teodor Östlund on 2014-02-18.
//  Copyright (c) 2014 Rosquist Östlund. All rights reserved.
//

#import "AppDelegate.h"
#import "HomeViewController.h"
#import "ExploreViewController.h"
#import "RateViewController.h"
#import "NotificationViewController.h"
#import "ProfileViewController.h"
#import "RateSearchViewController.h"
#import "Parse/Parse.h"
#import "GTScrollNavigationBar.h"

@implementation AppDelegate

@synthesize tabBarController;
@synthesize window;
@synthesize badge;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [Parse setApplicationId:@"LkmDnlPFo5EMB1o30VRxUaUwFG9q891pic8oobsp"
                  clientKey:@"zpwuevUaEySDKdFuSf1mQ5b30J8wrrj2xl8Ndkce"];
    
    [application registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound];
    
    NSDictionary *notificationPayload = launchOptions[UIApplicationLaunchOptionsRemoteNotificationKey];
    
    if ([PFUser currentUser] && notificationPayload != nil){
        
        
        // Create a pointer to the Photo object
        NSString *userId = [notificationPayload objectForKey:@"userId"];
        PFQuery *query = [PFUser query];
        [query whereKey:@"objectId" equalTo:userId];
        //PFUser *user = (PFUser*)[query getFirstObject];
        
        NSLog(@"hej");
        
        //ProfileViewController *viewController = [[ProfileViewController alloc] initWithUser:user];
        //[home.navigationController pushViewController:viewController animated:YES];
        
    }

    

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor colorWithRed:0.96 green:0.96 blue:0.94 alpha:1];
    [self.window makeKeyAndVisible];
    
    //[[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithRed:0.855 green:0.243 blue:0.251 alpha:1]}];
    [[UINavigationBar appearance] setTintColor:[UIColor colorWithRed:0.855 green:0.243 blue:0.251 alpha:1]];


    
    [self setupTabBarController];
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO];

    
    return YES;
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    if (self.tabBarController.selectedIndex==2) {
        [self.tabBarController.tabBar setSelectionIndicatorImage:nil];
    } else {
        [self.tabBarController.tabBar setSelectionIndicatorImage:[UIImage imageNamed:@"tab-bar_selected"]];
    }
}

- (void)setupTabBarController{
    NSLog(@"Skapar vyer");
    
    self.tabBarController = [[UITabBarController alloc] init];
    self.tabBarController.delegate = self;
    
    HomeViewController* home = [[HomeViewController alloc] init];
    ExploreViewController* explore = [[ExploreViewController alloc] init];
    RateSearchViewController* rateSearch = [[RateSearchViewController alloc] init];
    NotificationViewController* activity = [[NotificationViewController alloc] init];
    
    ProfileViewController* profile;
    
    if ([PFUser currentUser])
        profile = [[ProfileViewController alloc] initWithUser:[PFUser currentUser]];
    else
        profile = [[ProfileViewController alloc] init];
    
    UINavigationController *homeNav = [[UINavigationController alloc] initWithRootViewController:home];
    UINavigationController *exploreNav = [[UINavigationController alloc] initWithRootViewController:explore];
    UINavigationController *rateNav = [[UINavigationController alloc] initWithRootViewController:rateSearch];
    UINavigationController *activityNav = [[UINavigationController alloc] initWithRootViewController:activity];
    UINavigationController *profileNav = [[UINavigationController alloc] initWithRootViewController:profile];
    
    NSArray* controllers = [NSArray arrayWithObjects:homeNav, exploreNav, rateNav, activityNav, profileNav, nil];
    self.tabBarController.viewControllers = controllers;
    
    UITabBar *tabBar = self.tabBarController.tabBar;
    UITabBarItem *homeTabBarItem = [tabBar.items objectAtIndex:0];
    UITabBarItem *exploreTabBarItem = [tabBar.items objectAtIndex:1];
    UITabBarItem *rateTabBarItem = [tabBar.items objectAtIndex:2];
    UITabBarItem *activityTabBarItem = [tabBar.items objectAtIndex:3];
    UITabBarItem *profileTabBarItem = [tabBar.items objectAtIndex:4];
    
    homeTabBarItem.selectedImage = [[UIImage imageNamed:@"menu_home"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ];
    homeTabBarItem.image = [[UIImage imageNamed:@"menu_home_unselected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ];
    homeTabBarItem.title = nil;
    homeTabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
    
    exploreTabBarItem.selectedImage = [[UIImage imageNamed:@"menu_explore"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ];
    exploreTabBarItem.image = [[UIImage imageNamed:@"menu_explore_unselected"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ];
    exploreTabBarItem.title = nil;
    exploreTabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
    
    rateTabBarItem.selectedImage = [[UIImage imageNamed:@"menu_rate"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ];
    rateTabBarItem.image = [[UIImage imageNamed:@"menu_rate_unselected"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ];
    rateTabBarItem.title = nil;
    rateTabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
    
    activityTabBarItem.selectedImage = [[UIImage imageNamed:@"menu_activity"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ];
    activityTabBarItem.image = [[UIImage imageNamed:@"menu_activity_unselected"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ];
    activityTabBarItem.title = nil;
    activityTabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
    
    profileTabBarItem.selectedImage = [[UIImage imageNamed:@"menu_profile"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ];
    profileTabBarItem.image = [[UIImage imageNamed:@"menu_profile_unselected"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ];
    profileTabBarItem.title = nil;
    profileTabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
    
    [tabBar setBackgroundImage:[UIImage imageNamed:@"tab-bar"]];
    self.window.rootViewController = self.tabBarController;
    
    if (![PFUser currentUser]) {
        NotLoggedInViewController *loginView = [[NotLoggedInViewController alloc] init];
        UINavigationController *logInNav = [[UINavigationController alloc] initWithRootViewController:loginView];
        logInNav.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self.window.rootViewController presentViewController:logInNav animated:NO completion:nil];
    }
    
    
    if ([PFUser currentUser]){
        PFInstallation *currentInstallation = [PFInstallation currentInstallation];
        currentInstallation[@"installationUser"] = [[PFUser currentUser]objectId];
        [[PFInstallation currentInstallation] setObject:[PFUser currentUser] forKey:@"user"];
        [[PFInstallation currentInstallation] saveEventually];
        // here we add a column to the installation table and store the current user’s ID
        // this way we can target specific users later
        
        // while we’re at it, this is a good place to reset our app’s badge count
        // you have to do this locally as well as on the parse server by updating
        // the PFInstallation object
        if (currentInstallation.badge != 0) {
            currentInstallation.badge = 0;
            [currentInstallation saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (error) {
                    // Handle error here with an alert…
                }
                else {
                    // only update locally if the remote update succeeded so they always match
                    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
                    NSLog(@"updated badge");
                }
            }];
        }
    }
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    // Store the deviceToken in the current installation and save it to Parse.
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation setDeviceTokenFromData:deviceToken];
    if ([PFUser currentUser]){
        [[PFInstallation currentInstallation] setObject:[PFUser currentUser] forKey:@"user"];
        [[PFInstallation currentInstallation] saveEventually];
    }
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [PFPush handlePush:userInfo];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))handler {
    
    if ([PFUser currentUser]){
        PFInstallation *currentInstallation = [PFInstallation currentInstallation];
        currentInstallation[@"installationUser"] = [[PFUser currentUser]objectId];

        badge++;
        
        [[[[[self tabBarController] tabBar] items]
          objectAtIndex:3] setBadgeValue:[NSString stringWithFormat:@"%i", badge]];
        
        /*
        // Create a pointer to the Photo object
        NSString *userId = [userInfo objectForKey:@"userId"];
        PFQuery *query = [PFUser query];
        [query whereKey:@"objectId" equalTo:userId];
        PFUser *user = (PFUser*)[query getFirstObject];
        
        UINavigationController *navigationController = (UINavigationController *) [[self tabBarController] selectedViewController];
        ProfileViewController *viewController = [[ProfileViewController alloc] initWithUser:user];
        [navigationController pushViewController:viewController animated:YES];
        
        //ProfileViewController *viewController = [[ProfileViewController alloc] initWithUser:user];
        //[home.navigationController pushViewController:viewController animated:YES];
         */
        
    }
    
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    if ([PFUser currentUser]){
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    currentInstallation[@"installationUser"] = [[PFUser currentUser]objectId];
    // here we add a column to the installation table and store the current user’s ID
    // this way we can target specific users later
    
    // while we’re at it, this is a good place to reset our app’s badge count
    // you have to do this locally as well as on the parse server by updating
    // the PFInstallation object
    if (currentInstallation.badge != 0) {
        currentInstallation.badge = 0;
        [currentInstallation saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (error) {
                // Handle error here with an alert…
            }
            else {
                // only update locally if the remote update succeeded so they always match
                [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
                NSLog(@"updated badge");
            }
        }];
    }
    }   
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
