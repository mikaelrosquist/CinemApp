
//
//  SettingsViewController.m
//  CinemApp
//
//  Created by Teodor Östlund on 2014-02-20.
//  Copyright (c) 2014 Rosquist Östlund. All rights reserved.
//

#import "SettingsViewController.h"
#import "Parse/Parse.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController

@synthesize tableView, accountSection, generalSection, aboutSection;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    //Färg på navigationBaren
    UIImage *_defaultImage;
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
    [self.navigationController.navigationBar setBackgroundImage:_defaultImage forBarMetrics:UIBarMetricsDefault];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.navigationController.navigationBar.translucent = NO;
    [super viewWillAppear:animated];

}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setTitle:@"Table View"];
	
	self.accountSection = @[@"Change email", @"Change password", @"Privacy"];
    
    self.generalSection = @[@"Push notifications"];
    
    self.aboutSection = @[@"About", @"Follow us on Twitter"];
	
	[self.tableView setDelegate:self];
	[self.tableView setDataSource:self];
	self.edgesForExtendedLayout = UIRectEdgeNone;
    
    //Sätter knapparna i navigationBar till röda
    [self.navigationController.navigationBar setTintColor:[UIColor colorWithRed:0.855 green:0.243 blue:0.251 alpha:1]];
    
    //Gömmer "Back"-texten i navBar.
    //self.navigationController.navigationBar.topItem.title = @" ";
    
    //Skapar en "Save"-knapp
    //UIBarButtonItem* saveBarButton = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:nil];
    //self.navigationItem.rightBarButtonItem = saveBarButton;
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleDefault;
}

- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView
{
	// This enables the user to scroll down the navbar by tapping the status bar.
	return YES;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (section) {
    case 0:
        return @"ACCOUNT";
        
    case 1:
        return @"GENERAL";
    
    case 2:
        return @"ABOUT";
            
    }
    
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	if(section==0)
        return self.accountSection.count;
    else if(section==1)
        return self.generalSection.count;
    else if(section==2)
        return self.aboutSection.count;
    
    return 1;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"Identifier"];
	if (!cell) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Identifier"];
	}
	
    if(indexPath.section == 0){
        cell.textLabel.text = self.accountSection[indexPath.row];
    }
    else if(indexPath.section == 1){
        cell.textLabel.text = self.generalSection[indexPath.row];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    else if(indexPath.section == 2){
        cell.textLabel.text = self.aboutSection[indexPath.row];
    }
    else {
        cell.textLabel.text = @"Logout";
    }
		
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(indexPath.section==0)
    {
        if(indexPath.row==0)
        {
            //Och så vidare...
        }
    }
    else if(indexPath.section==1)
    {
        if(indexPath.row==0)
        {
            //Och så vidare...
        }
    }
    else if(indexPath.section==2)
    {
        if(indexPath.row==0)
        {
            //Och så vidare...
        }
    }
    else if(indexPath.section==3)
    {
        if(indexPath.row==0)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Logout"
                                                            message:@"Are you sure you want to logout?"
                                                           delegate:self
                                                  cancelButtonTitle:@"Cancel"
                                                  otherButtonTitles:@"OK", nil];
            
            [alert show];
        }
    }
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [PFUser logOut];
        [self.navigationController popViewControllerAnimated:YES];
        NSLog(@"Användaren utloggad");
    }
    else if (buttonIndex == 0) {
        // this is cancel button
    }
}

@end
