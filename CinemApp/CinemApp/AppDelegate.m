//
//  AppDelegate.m
//  CinemApp
//
//  Created by mikael on 30/01/14.
//
//

#import "AppDelegate.h"
#import <Parse/Parse.h>

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [Parse setApplicationId:@"LkmDnlPFo5EMB1o30VRxUaUwFG9q891pic8oobsp"
                  clientKey:@"zpwuevUaEySDKdFuSf1mQ5b30J8wrrj2xl8Ndkce"];
    
    UITabBarController *tabBarController = (UITabBarController *)self.window.rootViewController;
    UITabBar *tabBar = tabBarController.tabBar;
    UITabBarItem *tabBarItem1 = [tabBar.items objectAtIndex:0];
    UITabBarItem *tabBarItem2 = [tabBar.items objectAtIndex:1];
    UITabBarItem *tabBarItem3 = [tabBar.items objectAtIndex:2];
    UITabBarItem *tabBarItem4 = [tabBar.items objectAtIndex:3];
    UITabBarItem *tabBarItem5 = [tabBar.items objectAtIndex:4];
    
    tabBarItem1.selectedImage = [[UIImage imageNamed:@"menu_home"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ];
    tabBarItem1.image = [[UIImage imageNamed:@"menu_home_unselected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ];
    tabBarItem1.title = nil;
    
    tabBarItem2.selectedImage = [[UIImage imageNamed:@"menu_explore"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ];
    tabBarItem2.image = [[UIImage imageNamed:@"menu_explore_unselected"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ];
    tabBarItem2.title = nil;
    
    tabBarItem3.selectedImage = [[UIImage imageNamed:@"menu_rate"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ];
    tabBarItem3.image = [[UIImage imageNamed:@"menu_rate"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ];
    tabBarItem3.title = nil;
    
    tabBarItem4.selectedImage = [[UIImage imageNamed:@"menu_activity"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ];
    tabBarItem4.image = [[UIImage imageNamed:@"menu_activity_unselected"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ];
    tabBarItem4.title = nil;
    
    tabBarItem5.selectedImage = [[UIImage imageNamed:@"menu_profile"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ];
    tabBarItem5.image = [[UIImage imageNamed:@"menu_profile_unselected"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ];
    tabBarItem5.title = nil;
    
    [tabBar setBackgroundImage:[UIImage imageNamed:@"tab-bar"]];
    [tabBar setSelectionIndicatorImage:[UIImage imageNamed:@"tab-bar_selected"]];
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
}

- (void)applicationWillTerminate:(UIApplication *)application
{
}

@end
