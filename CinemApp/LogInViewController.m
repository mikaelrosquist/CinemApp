//
//  LogInViewController.m
//  CinemApp
//
//  Created by Teodor Östlund on 2014-04-28.
//  Copyright (c) 2014 Rosquist Östlund. All rights reserved.
//

#import "LogInViewController.h"
#import "Parse/Parse.h"
#import "DejalActivityView.h"
#import "AppDelegate.h"

@interface LogInViewController (){
    NSArray* placeholders;
    UITextField *cellTextField;
    NSString *usernameData, *passwordData;
}

@end

@implementation LogInViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Current user";
	
	placeholders = @[@"Username", @"Password"];
    
	[self.tableView setDelegate:self];
	[self.tableView setDataSource:self];
	self.edgesForExtendedLayout = UIRectEdgeNone;
    
    //Sätter knapparna i navigationBar till röda
    [self.navigationController.navigationBar setTintColor:[UIColor colorWithRed:0.855 green:0.243 blue:0.251 alpha:1]];
    
    //Färg på navigationBaren
    UIImage *_defaultImage;
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleDefault;
    [self.navigationController.navigationBar setBackgroundImage:_defaultImage forBarMetrics:UIBarMetricsDefault];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.navigationController.navigationBar.translucent = NO;
    
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"Sign in"
                                                                     style:UIBarButtonItemStylePlain
                                                                    target:self
                                                                    action:@selector(logIn:)];
    
    self.navigationItem.rightBarButtonItem = barButtonItem;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleDefault;
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated{
    [self.view resignFirstResponder];
    [super viewWillDisappear:animated];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *Identifier = [NSString stringWithFormat:@"Cell%@", indexPath];
	UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Identifier];
    
    cellTextField = [[UITextField alloc] initWithFrame:CGRectMake(52, 8, 262, 30)];
    cellTextField.adjustsFontSizeToFitWidth = YES;
    cellTextField.textColor = [UIColor blackColor];
    cellTextField.backgroundColor = [UIColor whiteColor];
    cellTextField.autocorrectionType = UITextAutocorrectionTypeNo; //stäng av autocorrect
    cellTextField.autocapitalizationType = UITextAutocapitalizationTypeNone; //stäng av autoversaler
    cellTextField.clearButtonMode = UITextFieldViewModeWhileEditing; //'x'-knappen
    [cellTextField setEnabled: YES];
    cellTextField.keyboardType = UIKeyboardTypeEmailAddress;
    cellTextField.returnKeyType = UIReturnKeyNext;
    cellTextField.placeholder = placeholders[indexPath.row];
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    
    if ([indexPath row] == 0){
        imgView.image = [UIImage imageNamed:@"settings_username"];
        cellTextField.returnKeyType = UIReturnKeyNext;
        cellTextField.secureTextEntry = NO;
    }else if ([indexPath row] == 1){
        imgView.image = [UIImage imageNamed:@"settings_password"];
        cellTextField.returnKeyType = UIReturnKeyDone;
        cellTextField.secureTextEntry = YES;
    }
    
    cellTextField.delegate = self;
    
    [cellTextField setTag:[indexPath row]];
    
    [[cellTextField viewWithTag:0] performSelector:@selector(becomeFirstResponder) withObject:nil afterDelay:0.6];

    cell.imageView.image = imgView.image;
    [cell.contentView addSubview:cellTextField];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
	return cell;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSMutableString *testString = [NSMutableString stringWithString:textField.text];
    [testString replaceCharactersInRange:range withString:string];
    switch (textField.tag) {
        case 0:
            usernameData = testString;
            break;
        case 1:
            passwordData = testString;
            break;
        default:
            break;
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    UIView *view = [self.view viewWithTag:textField.tag + 1];
    if (!view){
        [textField resignFirstResponder];
        [self logIn:self];
    }else
        [view becomeFirstResponder];
    
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)logIn:(id)sender {
    
    if(usernameData != nil && passwordData != nil){
        [DejalBezelActivityView activityViewForView:self.navigationController.navigationBar.superview withLabel:@"Signing in..."].showNetworkActivityIndicator = YES;
        
        [PFUser logInWithUsernameInBackground:usernameData password:passwordData
                                        block:^(PFUser *user, NSError *error) {
                                            if (user) {
                                                NSLog(@"Inloggning lyckades!");
                                                AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                                                [appDelegate setupTabBarController];
                                            } else {
                                                NSString *errorString = [error userInfo][@"error"];
                                                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                                                message:errorString
                                                                                               delegate:self
                                                                                      cancelButtonTitle:@"OK"
                                                                                      otherButtonTitles:nil];
                                                
                                                [alert show];
                                            }
                                            [DejalBezelActivityView removeView];
                                        }];
        
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"Please fill in all the fields"
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        
        [alert show];
    }
}
@end
