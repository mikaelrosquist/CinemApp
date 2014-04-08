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
#import "ActivityViewController.h"
#import "ProfileViewController.h"
#import "RateSearchViewController.h"
#import "Parse/Parse.h"
#import <JLTMDbClient.h>

@implementation AppDelegate

@synthesize tabBarController;
@synthesize window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [Parse setApplicationId:@"LkmDnlPFo5EMB1o30VRxUaUwFG9q891pic8oobsp"
                  clientKey:@"zpwuevUaEySDKdFuSf1mQ5b30J8wrrj2xl8Ndkce"];
    
    [[JLTMDbClient sharedAPIInstance] setAPIKey:@"2da45d86a9897bdf7e7eab86aa0485e3"];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor colorWithRed:0.96 green:0.96 blue:0.94 alpha:1];
    [self.window makeKeyAndVisible];
    
    self.tabBarController = [[UITabBarController alloc] init];
    
    HomeViewController* home = [[HomeViewController alloc] init];
    ExploreViewController* explore = [[ExploreViewController alloc] init];
    RateSearchViewController* rateSearch = [[RateSearchViewController alloc] init];
    //RateViewController* rate = [[RateViewController alloc] init];
    ActivityViewController* activity = [[ActivityViewController alloc] init];
    ProfileViewController* profile = [[ProfileViewController alloc] init];
    
    UINavigationController *homeNav = [[UINavigationController alloc] initWithRootViewController:home];
    UINavigationController *exploreNav = [[UINavigationController alloc] initWithRootViewController:explore];
    UINavigationController *rateNav = [[UINavigationController alloc] initWithRootViewController:rateSearch];
    UINavigationController *activityNav = [[UINavigationController alloc] initWithRootViewController:activity];
    UINavigationController *profileNav = [[UINavigationController alloc] initWithRootViewController:profile];
    
    [profileNav.navigationBar setBackgroundImage:[UIImage new]
                                   forBarMetrics:UIBarMetricsDefault];
    profileNav.navigationBar.shadowImage = [UIImage new];
    profileNav.navigationBar.translucent = YES;
    profileNav.view.backgroundColor = [UIColor clearColor];
    profileNav.navigationBar.barStyle = UIBarStyleBlack;
/*
    [rateNav.navigationBar setBackgroundImage:[UIImage new]
                                   forBarMetrics:UIBarMetricsDefault];
    rateNav.navigationBar.shadowImage = [UIImage new];
    rateNav.navigationBar.translucent = YES;
    rateNav.view.backgroundColor = [UIColor clearColor];
    rateNav.navigationBar.barStyle = UIBarStyleBlack;
  */      
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
    
    
    [tabBar setSelectionIndicatorImage:[UIImage imageNamed:@"tab-bar_selected"]];
    [tabBar setBackgroundImage:[UIImage imageNamed:@"tab-bar"]];
    
    self.window.rootViewController = self.tabBarController;
    
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];

    
    return YES;
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
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
