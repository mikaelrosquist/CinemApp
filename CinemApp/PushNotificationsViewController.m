
//
//  SettingsViewController.m
//  CinemApp
//
//  Created by Teodor Östlund on 2014-02-20.
//  Copyright (c) 2014 Rosquist Östlund. All rights reserved.
//

#import "PushNotificationsViewController.h"
#import "Parse/Parse.h"

@interface PushNotificationsViewController ()

@end

@implementation PushNotificationsViewController

@synthesize likesSection, commentsSection, followersSection;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleDefault;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setTitle:@"Push notifications"];
	
	self.likesSection = @[@"Off", @"From people I follow", @"On"];
    
    self.commentsSection = @[@"Off", @"From people I follow", @"On"];
    
    self.followersSection = @[@"Off", @"On"];
	
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
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return @"NOTIFICATIONS FOR LIKES";
        case 1:
            return @"NOTIFICATIONS FOR COMMENTS";
        case 2:
            return @"NOTIFICATIONS FOR NEW FOLLOWERS";
            
    }
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	if(section==0)
        return self.likesSection.count;
    else if(section==1)
        return self.commentsSection.count;
    else if(section==2)
        return self.followersSection.count;
    
    return 1;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"Identifier"];
	if (!cell) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Identifier"];
	}
	
    if(indexPath.section == 0){
        cell.textLabel.text = self.likesSection[indexPath.row];
        if(indexPath.row == 0)
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else if(indexPath.section == 1){
        cell.textLabel.text = self.commentsSection[indexPath.row];
        if(indexPath.row == 0)
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else if(indexPath.section == 2){
        cell.textLabel.text = self.followersSection[indexPath.row];
        if(indexPath.row == 0)
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
@end
