
//
//  SettingsViewController.m
//  CinemApp
//
//  Created by Teodor Östlund on 2014-02-20.
//  Copyright (c) 2014 Rosquist Östlund. All rights reserved.
//

#import "ProfileSettingsViewController.h"
#import "Parse/Parse.h"

@interface ProfileSettingsViewController ()

@end

@implementation ProfileSettingsViewController

@synthesize personalSection, contactSection, privateProfileSection, removeAccountSection;

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
    
    [self setTitle:@"Profile settings"];
	
	self.personalSection = @[@"Nickname", @"Profile picture"];
    
    self.contactSection = @[@"Email"];
    
    self.privateProfileSection = @[@"Private profile"];
    
    self.removeAccountSection = @[@"Remove account"];
	
	[self.tableView setDelegate:self];
	[self.tableView setDataSource:self];
	self.edgesForExtendedLayout = UIRectEdgeNone;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return @"Public information";
            
        case 1:
            return @"Contact information";
            
    }
    
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	if(section==0)
        return self.personalSection.count;
    else if(section==1)
        return self.contactSection.count;
    else if(section==2)
        return self.privateProfileSection.count;
    else if(section==3)
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
        cell.textLabel.text = self.personalSection[indexPath.row];
    }
    else if(indexPath.section == 1){
        cell.textLabel.text = self.contactSection[indexPath.row];
    }
    else if(indexPath.section == 2){
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
    else if(indexPath.section == 3){
        cell.textLabel.text = self.removeAccountSection[indexPath.row];
    }
    else{
        cell.textLabel.text = nil;
    }
    
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
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


@end
