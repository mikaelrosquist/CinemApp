
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
    NSString *fullName;
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
	
	self.personalSection = @[@"Full name", @"Profile picture", @"Cover photo"];
    
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
    
    PFUser *user = [PFUser currentUser];
    PFQuery *query = [PFUser query];
    [query whereKey:@"objectId" equalTo:user.objectId];
    query.limit = 1;
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            if (objects.count > 0) {
                PFObject *_user = [objects objectAtIndex:0];
                fullName = [_user objectForKey:@"fullname"];
            }
        }
    }];
    
    NSLog(@"%@", fullName);


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
        return @"User information";
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
        if(indexPath.row == 0){
        
            UITextField *playerTextField = [[UITextField alloc] initWithFrame:CGRectMake(52, 8, 260, 30)];
            playerTextField.adjustsFontSizeToFitWidth = YES;
            playerTextField.textColor = [UIColor blackColor];
            playerTextField.backgroundColor = [UIColor whiteColor];
            playerTextField.autocorrectionType = UITextAutocorrectionTypeNo; //stäng av autocorrect
            playerTextField.autocapitalizationType = UITextAutocapitalizationTypeNone; //stäng av autoversaler
            playerTextField.clearButtonMode = UITextFieldViewModeWhileEditing; //'x'-knappen
            playerTextField.tag = 0;
            [playerTextField setEnabled: YES];
            playerTextField.keyboardType = UIKeyboardTypeEmailAddress;
            playerTextField.returnKeyType = UIReturnKeyNext;
            playerTextField.placeholder = self.personalSection[indexPath.row];
            UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
            
            if ([indexPath row] == 0){
                imgView.image = [UIImage imageNamed:@"settings_username"];
                if(![fullName  isEqual: [NSNull null]])
                    playerTextField.text = fullName;
                
                playerTextField.returnKeyType = UIReturnKeyNext;
            }
            
            [playerTextField setTag:[indexPath row]];
            playerTextField.delegate = self;
            
            cell.imageView.image = imgView.image;
            playerTextField.secureTextEntry = NO;
            [cell.contentView addSubview:playerTextField];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }else{
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.userInteractionEnabled = NO;
            cell.textLabel.text = self.personalSection[indexPath.row];
        }
    }
    
    else if(indexPath.section == 1){
        cell.textLabel.text = self.privateProfileSection[indexPath.row];
        UISwitch *switchView = [[UISwitch alloc] initWithFrame:CGRectZero];
        cell.accessoryView = switchView;
        [switchView addTarget:self action:@selector(updateSwitchAtIndexPath:) forControlEvents:UIControlEventTouchUpInside];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *privateProfile = [defaults objectForKey:@"privateProfile"];
        
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
