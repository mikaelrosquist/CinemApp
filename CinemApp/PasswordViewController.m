
//
//  SettingsViewController.m
//  CinemApp
//
//  Created by Teodor Östlund on 2014-02-20.
//  Copyright (c) 2014 Rosquist Östlund. All rights reserved.
//

#import "PasswordViewController.h"
#import "Parse/Parse.h"

@interface PasswordViewController ()

@end

@implementation PasswordViewController

@synthesize currentPasswordSection, changePasswordSection;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self setTitle:@"Change Password"];
	
	self.currentPasswordSection = @[@"Nickname"];
    
    self.changePasswordSection = @[@"Email", @"hej"];
	
	[self.tableView setDelegate:self];
	[self.tableView setDataSource:self];
	self.edgesForExtendedLayout = UIRectEdgeNone;
    
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"Save"
                                                                   style:UIBarButtonItemStylePlain
                                                                  target:self
                                                                  action:@selector(save)];
    
    self.navigationItem.rightBarButtonItem = barButtonItem;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	if(section==0)
        return 1;
    else if(section==1)
        return 2;
    
    return 1;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"Identifier"];
	if (!cell) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Identifier"];
	}
    
    cell.accessoryType = UITableViewCellAccessoryNone;
	
    UITextField *playerTextField = [[UITextField alloc] initWithFrame:CGRectMake(20, 8, 300, 30)];
    playerTextField.adjustsFontSizeToFitWidth = YES;
    playerTextField.textColor = [UIColor blackColor];
    
    playerTextField.backgroundColor = [UIColor whiteColor];
    playerTextField.autocorrectionType = UITextAutocorrectionTypeNo; // no auto correction support
    playerTextField.autocapitalizationType = UITextAutocapitalizationTypeNone; // no auto capitalization support
    playerTextField.tag = 0;
    playerTextField.clearButtonMode = UITextFieldViewModeNever; // no clear 'x' button to the right
    [playerTextField setEnabled: YES];
    playerTextField.keyboardType = UIKeyboardTypeEmailAddress;
    playerTextField.returnKeyType = UIReturnKeyNext;
    if(indexPath.section == 0){
        playerTextField.placeholder = @"Current password";
    }else if(indexPath.section == 1){
        if ([indexPath row] == 0)
            playerTextField.placeholder = @"New password";
        else if ([indexPath row] == 1)
            playerTextField.placeholder = @"New password, again";
    }
    playerTextField.secureTextEntry = YES;
    [cell.contentView addSubview:playerTextField];
    
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

@end