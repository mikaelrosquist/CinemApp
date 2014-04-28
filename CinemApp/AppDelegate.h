#import <UIKit/UIKit.h>
#import "NotLoggedInViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, UITabBarControllerDelegate>{
    UITabBarController *tabBarController;
}

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UITabBarController *tabBarController;
@property (nonatomic, strong) NotLoggedInViewController* loginView;


@end
