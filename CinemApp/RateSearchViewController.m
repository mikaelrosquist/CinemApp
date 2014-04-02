#import "RateSearchViewController.h"

@interface RateSearchViewController ()



@end

#define getDataURL @"http://api.themoviedb.org/3/search/movie?include_adault=false&search_type=phrase&api_key=2da45d86a9897bdf7e7eab86aa0485e3&query="

@implementation RateSearchViewController{
    NSString *searchQuery;
}

@synthesize json, resultArray, mainTableView, moviesArray, activityIndicatorView, searchBar;


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 300, 44)];
    [searchBar setDelegate:self];
    [searchBar setShowsCancelButton:NO];
    [[self navigationItem] setTitleView:searchBar];
    searchBar.placeholder = @"Search";
    searchBar.barTintColor = [UIColor lightGrayColor];
    searchBar.tintColor = [UIColor colorWithRed:0.855 green:0.243 blue:0.251 alpha:1];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(refresh) forControlEvents:UIControlEventValueChanged];
    //[self refresh];

    //self.activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    //self.activityIndicatorView.hidesWhenStopped = YES;
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [searchBar becomeFirstResponder];
    [super viewWillAppear:animated];
}

-(void)refresh {
    [mainTableView reloadData];
    [self.refreshControl endRefreshing];
}

//SÖK DELEGATE METHODS
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
	[self.searchBar becomeFirstResponder];
	[self.searchBar setShowsCancelButton:YES animated:YES];
}
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
	[self.searchBar resignFirstResponder];
	[self.searchBar setShowsCancelButton:NO animated:YES];
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
	[self.searchBar resignFirstResponder];
	[self.searchBar setShowsCancelButton:NO animated:YES];
    searchQuery = self.searchBar.text;
    //[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [self retrieveData];
    //[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [mainTableView reloadData];
}
- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar {
	[self.searchBar resignFirstResponder];
	[self.searchBar setShowsCancelButton:NO animated:YES];
}

//TABLE
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    
    cell.textLabel.text = [[moviesArray objectAtIndex:indexPath.row] valueForKey:@"original_title"];
    cell.detailTextLabel.text = [[moviesArray objectAtIndex:indexPath.row] valueForKey:@"release_date"];;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    NSLog(@"%@", [[moviesArray objectAtIndex:indexPath.row] valueForKey:@"original_title"]);

    return cell;
}

//TABLE DELEGATE METHODS
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    RateViewController * dvc = [[RateViewController alloc]init];
    
    //Retrieve the current selected movie
    dvc.movieID = [[moviesArray objectAtIndex:indexPath.row] valueForKey:@"id"];
    dvc.movieName = [[moviesArray objectAtIndex:indexPath.row] valueForKey:@"original_title"];
    dvc.movieRelease = [[moviesArray objectAtIndex:indexPath.row] valueForKey:@"release_date"];
    dvc.movieGenre = [[moviesArray objectAtIndex:indexPath.row] valueForKey:@"release_date"];
    dvc.movieRuntime = [[moviesArray objectAtIndex:indexPath.row] valueForKey:@"runtime"];
    dvc.movieBackground = [[moviesArray objectAtIndex:indexPath.row] valueForKey:@"backdrop_path"];

    NSLog(@"%@", [[moviesArray objectAtIndex:indexPath.row] valueForKey:@"original_title"]);
    
    [self.navigationController pushViewController:dvc animated:YES];
}

//HÄMTA DATA
- (void) retrieveData
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", getDataURL, searchQuery]];
    NSData *data = [NSData dataWithContentsOfURL:url];
    
    json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    
    moviesArray = [[NSMutableArray alloc] init];
    moviesArray = [json objectForKey:@"results"];
    
    NSLog(@"%@", moviesArray);
    
    [mainTableView reloadData];
}

@end
