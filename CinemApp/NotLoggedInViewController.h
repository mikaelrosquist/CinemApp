//
//  LogInViewController.h
//  CinemApp
//
//  Created by Teodor Östlund on 2014-02-21.
//  Copyright (c) 2014 Rosquist Östlund. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SignUpWithEmailViewController.h"
#import "LogInViewController.h"

@interface NotLoggedInViewController : UIViewController

@property (nonatomic, strong) SignUpWithEmailViewController *signUpWithEmailViewController;
@property (nonatomic, strong) LogInViewController *logInViewController;

@end
