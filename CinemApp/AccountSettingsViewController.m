
//
//  SettingsViewController.m
//  CinemApp
//
//  Created by Teodor Östlund on 2014-02-20.
//  Copyright (c) 2014 Rosquist Östlund. All rights reserved.
//

#import "AccountSettingsViewController.h"
#import "Parse/Parse.h"

@interface AccountSettingsViewController ()

@end

@implementation AccountSettingsViewController

@synthesize passwordSection, removeAccountSection, passwordSettingsView;

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
    
    [self setTitle:@"Account settings"];
	
	self.passwordSection = @[@"Email", @"Change password"];
    
    self.removeAccountSection = @[@"Remove account"];
	
	[self.tableView setDelegate:self];
	[self.tableView setDataSource:self];
	self.edgesForExtendedLayout = UIRectEdgeNone;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	if(section==0)
        return self.passwordSection.count;
    else if(section==1)
        return self.removeAccountSection.count;
    
    return 1;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"Identifier"];
	if (!cell) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Identifier"];
	}
	
    if(indexPath.section == 0){
        if(indexPath.row == 0){
            
            UITextField *playerTextField = [[UITextField alloc] initWithFrame:CGRectMake(80, 8, 235, 30)];
            playerTextField.adjustsFontSizeToFitWidth = YES;
            playerTextField.textColor = [UIColor blackColor];
            playerTextField.backgroundColor = [UIColor whiteColor];
            playerTextField.autocorrectionType = UITextAutocorrectionTypeNo; // stäng av autocorrect
            playerTextField.autocapitalizationType = UITextAutocapitalizationTypeNone; // stäng av autoversaler
            playerTextField.tag = 0;
            playerTextField.clearButtonMode = UITextFieldViewModeAlways; // ta bort 'x'-knappen
            [playerTextField setEnabled: YES];
            playerTextField.keyboardType = UIKeyboardTypeEmailAddress;
            playerTextField.returnKeyType = UIReturnKeyNext;
            playerTextField.placeholder = @"admin@mail.com";
            
            playerTextField.secureTextEntry = NO;
            [cell.contentView addSubview:playerTextField];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }else{
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        cell.textLabel.text = self.passwordSection[indexPath.row];
    }
    else if(indexPath.section == 1){
        cell.textLabel.text = self.removeAccountSection[indexPath.row];
        cell.textLabel.textColor = [UIColor colorWithRed:0.855 green:0.243 blue:0.251 alpha:1];
    }
    
	return cell;
}


-(NSString *) tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    if (section == 1)
        return @"This will permanently remove your account. The username cannot be reused by anyone.";
    else
        return nil;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section==0){
        if(indexPath.row==1){
            passwordSettingsView = [[PasswordViewController alloc] initWithStyle:UITableViewStyleGrouped];
            [self.navigationController pushViewController:passwordSettingsView animated:YES];
        }
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"This function does not yet work"
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        
        [alert show];
    }
    
}


@end
