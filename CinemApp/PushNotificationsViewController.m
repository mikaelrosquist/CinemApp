
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

@synthesize notificationsSection;

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
	
	self.notificationsSection = @[@"Likes", @"Comments", @"New followers"];
	
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
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"NOTIFICATIONS";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.notificationsSection.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"Identifier"];
	if (!cell) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Identifier"];
	}
	
    cell.textLabel.text = self.notificationsSection[indexPath.row];
    UISwitch *switchView = [[UISwitch alloc] initWithFrame:CGRectZero];
    cell.accessoryView = switchView;
    switchView.tag = indexPath.row;
    [switchView addTarget:self action:@selector(updateSwitchAtIndexPath:) forControlEvents:UIControlEventTouchUpInside];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *likeNotification = [defaults objectForKey:@"likeNotification"];
    NSString *commentNotification = [defaults objectForKey:@"commentNotification"];
    NSString *followerNotification = [defaults objectForKey:@"followerNotification"];
    
    switch(indexPath.row)
    {
        case 0:
            ([likeNotification isEqual: @"ON"]) ? [switchView setOn:YES] : [switchView setOn:NO];
            break;
        case 1:
            ([commentNotification isEqual: @"ON"]) ? [switchView setOn:YES] : [switchView setOn:NO];
            break;
        case 2:
            ([followerNotification isEqual: @"ON"]) ? [switchView setOn:YES] : [switchView setOn:NO];
            break;
        default:
            NSLog(@"Error!");
    }

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(NSString *) tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    return @"You can change the overall notifications settings in your phones Settings application.";
}

- (void)updateSwitchAtIndexPath:(UISwitch *)switchView{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSString *likeNotification;
    NSString *commentNotification;
    NSString *followerNotification;
    
    switch(switchView.tag)
    {
        case 0:
            likeNotification = ([switchView isOn]) ? @"ON" : @"OFF";
            [defaults setObject:likeNotification forKey:@"likeNotification"];
            NSLog(@"Notifikationer för likes har satts till: %@", likeNotification);
            break;
        case 1:
            commentNotification = ([switchView isOn]) ? @"ON" : @"OFF";
            [defaults setObject:commentNotification forKey:@"commentNotification"];
            NSLog(@"Notifikationer för kommentarer har satts till: %@", commentNotification);
            break;
        case 2:
            followerNotification = ([switchView isOn]) ? @"ON" : @"OFF";
            [defaults setObject:followerNotification forKey:@"followerNotification"];
            NSLog(@"Notifikationer för nya följare har satts till: %@", followerNotification);
            break;
        default:
            NSLog(@"Error!");
    }
    [defaults synchronize];
    
}

@end
