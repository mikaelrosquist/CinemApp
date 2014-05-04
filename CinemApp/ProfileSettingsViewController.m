
//
//  SettingsViewController.m
//  CinemApp
//
//  Created by Teodor Östlund on 2014-02-20.
//  Copyright (c) 2014 Rosquist Östlund. All rights reserved.
//

#import "ProfileSettingsViewController.h"
#import "Parse/Parse.h"

@interface ProfileSettingsViewController (){
    PFUser *currentUser;
}

@end

@implementation ProfileSettingsViewController

@synthesize personalSection, privateProfileSection, removeAccountSection;

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
    
    currentUser = [PFUser currentUser];
    
    [self setTitle:@"Profile settings"];
	
	self.personalSection = @[@"Profile picture", @"Cover photo"];
    
    self.privateProfileSection = @[@"Private profile"];
	
    self.removeAccountSection = @[@"Remove account"];
    
	[self.tableView setDelegate:self];
	[self.tableView setDataSource:self];
	self.edgesForExtendedLayout = UIRectEdgeNone;
    
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"Save"
                                                                     style:UIBarButtonItemStylePlain
                                                                    target:self
                                                                    action:@selector(save:)];
    
    self.navigationItem.rightBarButtonItem = barButtonItem;


}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if(section == 0)
        return @"Profile data";
    else
        return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	if(section==0)
        return self.personalSection.count;
    else if(section==1)
        return self.privateProfileSection.count;
    else if(section==2)
        return self.removeAccountSection.count;
    
    return 1;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *Identifier = [NSString stringWithFormat:@"Cell%@", indexPath];
	UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Identifier];
	
    if(indexPath.section == 0){
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.userInteractionEnabled = NO;
            cell.textLabel.text = self.personalSection[indexPath.row];
    }
    
    else if(indexPath.section == 1){
        cell.textLabel.text = self.privateProfileSection[indexPath.row];
        UISwitch *switchView = [[UISwitch alloc] initWithFrame:CGRectZero];
        cell.accessoryView = switchView;
        [switchView addTarget:self action:@selector(updateSwitchAtIndexPath:) forControlEvents:UIControlEventTouchUpInside];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *privateProfile = [defaults objectForKey:@"privateProfile"];
        [switchView setEnabled:NO];
        if([privateProfile isEqual: @"ON"])
            [switchView setOn:YES animated:YES];
        else
            [switchView setOn:NO animated:YES];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    else if(indexPath.section == 2){
        cell.textLabel.text = self.removeAccountSection[indexPath.row];
        cell.textLabel.textColor = [UIColor colorWithRed:0.855 green:0.243 blue:0.251 alpha:1];
    }
	return cell;
}


-(NSString *) tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    if (section == 1)
        return @"Toggle to require authorization before anyone can follow you or see your ratings. Your existing followers won't be affected.";
    else if (section == 2)
        return @"This will permanently remove your account. The username cannot be reused by anyone.";
    else
        return nil;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section==2){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"This function does not yet work"
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        
        [alert show];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }

}

- (void)updateSwitchAtIndexPath:(UISwitch *)switchView {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *privateProfile;
    
    if ([switchView isOn])
        privateProfile = @"ON";
    else
        privateProfile = @"OFF";
    
    [defaults setObject:privateProfile forKey:@"privateProfile"];
    [defaults synchronize];
    NSLog(@"Privat profil har ändrats till: %@", privateProfile);
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
