//
//  SignUpWithEmailViewController.m
//  CinemApp
//
//  Created by Teodor Östlund on 2014-04-28.
//  Copyright (c) 2014 Rosquist Östlund. All rights reserved.
//

#import "SignUpWithEmailViewController.h"
#import "Parse/Parse.h"
#import "DejalActivityView.h"

@interface SignUpWithEmailViewController (){
    NSArray* placeholders;
    UITextField *cellTextField;
    NSString *emailData, *usernameData, *passwordData;
}

@end

@implementation SignUpWithEmailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"New account";
	
	placeholders = @[@"Email", @"Username", @"Password"];
    
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
    
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"Sign Up"
                                                                     style:UIBarButtonItemStylePlain
                                                                    target:self
                                                                    action:@selector(signUp:)];
    
    self.navigationItem.rightBarButtonItem = barButtonItem;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleDefault;
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *Identifier = [NSString stringWithFormat:@"Cell%@", indexPath];
	UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Identifier];
    
    cellTextField = [[UITextField alloc] initWithFrame:CGRectMake(52, 8, 260, 30)];
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
        imgView.image = [UIImage imageNamed:@"settings_email"];
        cellTextField.returnKeyType = UIReturnKeyNext;
        cellTextField.secureTextEntry = NO;
    }else if ([indexPath row] == 1){
        imgView.image = [UIImage imageNamed:@"settings_username"];
        cellTextField.returnKeyType = UIReturnKeyNext;
        cellTextField.secureTextEntry = NO;
    }else if ([indexPath row] == 2){
        imgView.image = [UIImage imageNamed:@"settings_password"];
        cellTextField.returnKeyType = UIReturnKeyDone;
        cellTextField.secureTextEntry = YES;
    }
    
    cellTextField.delegate = self;
    
    [cellTextField setTag:[indexPath row]];
    
    cell.imageView.image = imgView.image;
    [cell.contentView addSubview:cellTextField];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
	return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UILabel *footerLabel = nil;
    
    CGRect footerViewRect = CGRectMake(0, 3, tableView.bounds.size.width, 45.0);
    
    UIView *footerView = [[UIView alloc] initWithFrame:footerViewRect];
    
    if ( tableView.dataSource && [tableView.dataSource respondsToSelector:@selector(tableView:titleForFooterInSection:)]) {
        
        CGFloat labeInset = 10.0;
        
        CGRect footerLabelRect = CGRectInset(footerViewRect, labeInset, 0.0);
        
        footerLabel = [[UILabel alloc] initWithFrame:footerLabelRect];
        footerLabel.text = [tableView.dataSource tableView:tableView titleForFooterInSection:section];
        footerLabel.backgroundColor = [UIColor clearColor];
        footerLabel.font = [UIFont boldSystemFontOfSize:12];
        footerLabel.textColor = [UIColor grayColor];
        footerLabel.shadowOffset = CGSizeMake(1.0, 1.0);
        footerLabel.lineBreakMode = NSLineBreakByWordWrapping;
        footerLabel.numberOfLines = 0;
        footerLabel.textAlignment = NSTextAlignmentCenter;
        
        [footerView addSubview:footerLabel];
    }
    return footerView;
}

-(NSString *) tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    return @"By clicking Sign Up, you agree to our Terms of Service and that you have read our Data Use Policy.";
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSMutableString *testString = [NSMutableString stringWithString:textField.text];
    [testString replaceCharactersInRange:range withString:string];
    switch (textField.tag) {
        case 0:
            emailData = testString;
            break;
        case 1:
            usernameData = testString;
            break;
        case 2:
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
        [self signUp:self];
    }else
        [view becomeFirstResponder];
    
    return YES;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)signUp:(id)sender {
    [DejalBezelActivityView activityViewForView:self.view];
    if(emailData != nil && usernameData != nil && passwordData != nil){
        
        
        PFUser *user = [PFUser user];
        user.email = emailData;
        user.username = usernameData;
        user.password = passwordData;
        
        [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (!error) {
                NSLog(@"Användare skapad!!!");
                [[self presentingViewController] dismissViewControllerAnimated:YES completion:nil];
            } else {
                NSString *errorString = [error userInfo][@"error"];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                message:errorString
                                                               delegate:self
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
                
                [alert show];
            }
            [DejalBezelActivityView removeViewAnimated:YES];
        }];
    }
}

@end
