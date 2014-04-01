#import "RateSearchViewController.h"

@interface RateSearchViewController ()



@end

#define getDataURL @"http://api.themoviedb.org/3/search/movie?api_key=2da45d86a9897bdf7e7eab86aa0485e3&query="

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

    
    //[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [self retrieveData];
    //[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    //self.activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    //self.activityIndicatorView.hidesWhenStopped = YES;
    
    [self.mainTableView reloadData];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [searchBar becomeFirstResponder];
    [super viewWillAppear:animated];
}

-(void)refresh {
    // do something here to refresh.
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
    [self retrieveData];
    [self.mainTableView reloadData];
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
    return moviesArray.count;
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
    //Movie* selectedMovie = [resultArray objectAtIndex:indexPath.row];
    dvc.movieID = [[moviesArray objectAtIndex:indexPath.row] valueForKey:@"id"];
    dvc.movieName = [[moviesArray objectAtIndex:indexPath.row] valueForKey:@"original_title"];
    dvc.movieRelease = [[moviesArray objectAtIndex:indexPath.row] valueForKey:@"release_date"];
    //dvc.movieName = selectedMovie.movieName;
    //dvc.movieGenre = selectedMovie.movieGenre;
    //dvc.movieRuntime = selectedMovie.movieRuntime;
    dvc.movieBackground = [[moviesArray objectAtIndex:indexPath.row] valueForKey:@"backdrop_path"];

    NSLog(@"%@", [[moviesArray objectAtIndex:indexPath.row] valueForKey:@"original_title"]);
    
    [self.navigationController pushViewController:dvc animated:YES];

}

//HÄMTA DATA
- (void) retrieveData
{
    NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", getDataURL, @"indiana+jones"]];
    NSData * data = [NSData dataWithContentsOfURL:url];
    
    json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    
    resultArray = [[NSMutableArray alloc]init];
    moviesArray = [[NSMutableArray alloc] init];
    moviesArray = [json objectForKey:@"results"];
    
    NSLog(@"%@", [[moviesArray objectAtIndex:1] valueForKey:@"original_title"]);
    
    /*
    for (int i = 0; i < movieArray.count; i++)
    {
        //Create movie object
        NSString * mID = [[movieArray objectAtIndex:i] valueForKey:@"id"];
        NSString * mName = [[movieArray objectAtIndex:i] valueForKey:@"original_title"];
        NSString * mRelease = [[movieArray objectAtIndex:i] valueForKey:@"release_date"];
        NSString * mGenre = @"N/A";
        NSString * mRuntime = @"N/A";
        NSString * mBackground = [[movieArray objectAtIndex:i] valueForKey:@"backdrop_path"];
        Movie* movie = [[Movie alloc]initWithMovieID:mID andMovieName: mName andMovieRelease:mRelease andMovieGenre:mGenre andMovieRuntime:mRuntime andMovieBackgroundImageURL:mBackground];
        //Add our city object to our cities array
        [resultArray addObject:movie];
    }*/
    
    [self.mainTableView reloadData];
}

@end
