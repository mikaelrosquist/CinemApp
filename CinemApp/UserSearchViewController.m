//
//  PeopleSearchViewController.m
//  CinemApp
//
//  Created by Teodor Östlund on 2014-04-29.
//  Copyright (c) 2014 Rosquist Östlund. All rights reserved.
//

#import "UserSearchViewController.h"
#import "Reachability.h"
#import "Parse/Parse.h"
#import "ProfileViewController.h"


@interface UserSearchViewController ()

@end

@implementation UserSearchViewController{
    NSString *searchQuery;
}

@synthesize searchBar, usersArray;

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
    
    
	[self.tableView setDelegate:self];
	[self.tableView setDataSource:self];
	self.edgesForExtendedLayout = UIRectEdgeNone;
    
    //Sätter knapparna i navigationBar till röda
    [self.navigationController.navigationBar setTintColor:[UIColor colorWithRed:0.855 green:0.243 blue:0.251 alpha:1]];
    
    //Färg på navigationBaren
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    
    searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 300, 44)];
    [searchBar setDelegate:self];
    [searchBar setShowsCancelButton:NO];
    [[self navigationItem] setTitleView:searchBar];
    searchBar.placeholder = @"Search user";
    searchBar.tintColor = [UIColor colorWithRed:0.855 green:0.243 blue:0.251 alpha:1];
    [searchBar becomeFirstResponder];
    self.tableView.contentInset = UIEdgeInsetsMake(-35.0f, 0.0f, 0.0f, 0.0);
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [searchBar resignFirstResponder];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    UIImage *_defaultImage;
    [self.navigationController.navigationBar setBackgroundImage:_defaultImage forBarMetrics:UIBarMetricsDefault];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
	[self.searchBar becomeFirstResponder];
	[self.searchBar setShowsCancelButton:YES animated:YES];
    if([self.searchBar.text isEqualToString: @""]){
        [self.tableView reloadData];
        [self.tableView setHidden:NO];
    }
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
	[self.searchBar resignFirstResponder];
	[self.searchBar setShowsCancelButton:NO animated:YES];
    if([self.searchBar.text isEqualToString: @""]){
        [self.tableView reloadData];
        [self.tableView setHidden:NO];
    }
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
	[self.searchBar resignFirstResponder];
	[self.searchBar setShowsCancelButton:NO animated:YES];
    searchQuery = self.searchBar.text;
    [self retrieveData];
    
}

- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar {
	[self.searchBar resignFirstResponder];
    [self.searchBar setShowsCancelButton:NO animated:YES];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return usersArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    if(usersArray.count != 0){
        
        NSString *username = [[usersArray objectAtIndex:indexPath.row] valueForKey:@"username"];
    
        cell.textLabel.text = [NSString stringWithFormat:@"%@", username];
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 15, 15)];
        imgView.image = [UIImage imageNamed:@"settings_username"];
        cell.imageView.image = imgView.image;
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
    }
    return cell;
}

//TABLE DELEGATE METHODS
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.searchBar resignFirstResponder];
    
    ProfileViewController * profileVC = [[ProfileViewController alloc]initWithUser:[usersArray objectAtIndex:indexPath.row]];
    [self.navigationController pushViewController:profileVC animated:YES];
}


//HÄMTA DATA
- (void) retrieveData
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        if([self reachable])
        {
            PFQuery *query = [PFUser query];
            query.limit = 10;
            searchQuery = [searchQuery lowercaseString];
            
            [query whereKey:@"username" containsString:searchQuery];
            
            [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                if (!error) {
                    
                    usersArray = objects;
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [[self tableView] reloadData];
                        [self.refreshControl endRefreshing];
                        [self.tableView setHidden:NO];
                        //NSLog(@"HÄMTAT: Sökresultat för %@", usersArray);
                    });
    
                } else {
                    // Log details of the failure
                    NSLog(@"Error: %@ %@", error, [error userInfo]);
                }
            }];
            
            
            
        }else{
            
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"Not connected to internet");
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oops!"
                                                                message:@"Ain't no network connection available"
                                                               delegate:self
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
                
                [alert show];
                
            });
        };
    });
}

-(BOOL)reachable {
    Reachability *r = [Reachability reachabilityWithHostname:@"www.google.com"];
    NetworkStatus internetStatus = [r currentReachabilityStatus];
    if(internetStatus == NotReachable) {
        return NO;
    }
    return YES;
}

@end
