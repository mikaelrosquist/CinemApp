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
