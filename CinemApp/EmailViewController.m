
//
//  SettingsViewController.m
//  CinemApp
//
//  Created by Teodor Östlund on 2014-02-20.
//  Copyright (c) 2014 Rosquist Östlund. All rights reserved.
//

#import "EmailViewController.h"
#import "Parse/Parse.h"

@interface EmailViewController ()

@end

@implementation EmailViewController

@synthesize emailSection, passwordSection;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setTitle:@"Update email"];
	
	self.emailSection = @[@"New email"];
    
    self.passwordSection = @[@"Password"];
	
	[self.tableView setDelegate:self];
	[self.tableView setDataSource:self];
	self.edgesForExtendedLayout = UIRectEdgeNone;
    
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"Save"
                                                                     style:UIBarButtonItemStylePlain
                                                                    target:self
                                                                    action:@selector(save:)];
    
    self.navigationItem.rightBarButtonItem = barButtonItem;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"Identifier"];
	if (!cell) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Identifier"];
	}
    
    cell.accessoryType = UITableViewCellAccessoryNone;
	
    UITextField *playerTextField = [[UITextField alloc] initWithFrame:CGRectMake(55, 8, 260, 30)];
    playerTextField.adjustsFontSizeToFitWidth = YES;
    playerTextField.textColor = [UIColor blackColor];
    
    playerTextField.backgroundColor = [UIColor whiteColor];
    playerTextField.autocorrectionType = UITextAutocorrectionTypeNo; // no auto correction support
    playerTextField.autocapitalizationType = UITextAutocapitalizationTypeNone; // no auto capitalization support
    playerTextField.tag = 0;
    playerTextField.clearButtonMode = UITextFieldViewModeWhileEditing; // no clear 'x' button to the right
    [playerTextField setEnabled: NO]; //SÄTT TILL YES SEN
    playerTextField.keyboardType = UIKeyboardTypeEmailAddress;
    playerTextField.returnKeyType = UIReturnKeyNext;
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    if(indexPath.section == 0){
        playerTextField.placeholder = @"New email address";
        [playerTextField setTag:0];
        imgView.image = [UIImage imageNamed:@"settings_email"];
    }else if(indexPath.section == 1){
        playerTextField.placeholder = @"Password for security";
        playerTextField.returnKeyType = UIReturnKeyDone;
        [playerTextField setTag:1];
        imgView.image = [UIImage imageNamed:@"settings_password"];
    }
    playerTextField.delegate = self;
    playerTextField.secureTextEntry = YES;
    cell.imageView.image = imgView.image;
    [cell.contentView addSubview:playerTextField];
    cell.userInteractionEnabled = NO;
	return cell;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    UIView *view = [self.view viewWithTag:textField.tag + 1];
    if (!view)
        [textField resignFirstResponder];
    else
        [view becomeFirstResponder];
    return YES;
}

-(void)save:(id)sender {
    //kod
}

@end
