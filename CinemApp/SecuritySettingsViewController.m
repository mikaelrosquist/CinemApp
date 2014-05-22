//
//  SecuritySettingsViewController.m
//  CinemApp
//
//  Created by Teodor Östlund on 2014-04-30.
//  Copyright (c) 2014 Rosquist Östlund. All rights reserved.
//

#import "SecuritySettingsViewController.h"
#import "Parse/Parse.h"

@interface SecuritySettingsViewController (){
    PFUser *currentUser;
    NSArray *tableSection;
}

@end

@implementation SecuritySettingsViewController

@synthesize passwordSettingsView, emailSettingsView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    currentUser = [PFUser currentUser];
    
    [self setTitle:@"Security settings"];
	
	tableSection = @[@"Update email", @"Change password"];
    
	[self.tableView setDelegate:self];
	[self.tableView setDataSource:self];
	self.edgesForExtendedLayout = UIRectEdgeNone;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return tableSection.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *Identifier = [NSString stringWithFormat:@"Cell%@", indexPath];
	UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Identifier];
	
        if(indexPath.row == 0 || indexPath.row == 1){
            
            UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
            
            if ([indexPath row] == 0){
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                cell.textLabel.text = tableSection[indexPath.row];
                UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
                imgView.image = [UIImage imageNamed:@"settings_email"];
                cell.imageView.image = imgView.image;
            }else if ([indexPath row] == 1){
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                cell.textLabel.text = tableSection[indexPath.row];
                UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
                imgView.image = [UIImage imageNamed:@"settings_password"];
                cell.imageView.image = imgView.image;
                
            }
            
            cell.imageView.image = imgView.image;
        }else{
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.userInteractionEnabled = NO;
            cell.textLabel.text = tableSection[indexPath.row];
        }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.row==0){
        emailSettingsView = [[EmailViewController alloc] initWithStyle:UITableViewStyleGrouped];
        [self.navigationController pushViewController:emailSettingsView animated:YES];
    }
    else if(indexPath.row==1){
        passwordSettingsView = [[PasswordViewController alloc] initWithStyle:UITableViewStyleGrouped];
        [self.navigationController pushViewController:passwordSettingsView animated:YES];
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
