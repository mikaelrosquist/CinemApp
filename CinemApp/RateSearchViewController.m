#import "RateSearchViewController.h"

@interface RateSearchViewController ()



@end

#define getDataURL @"http://api.themoviedb.org/3/search/movie?api_key=2da45d86a9897bdf7e7eab86aa0485e3&query="

@implementation RateSearchViewController{
    
    NSString *searchQuery;
   
    
}

@synthesize json, resultArray, mainTableView, movieArray, activityIndicatorView;


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 300, 44)];
    [searchBar setDelegate:self];
    [searchBar setShowsCancelButton:NO];
    [[self navigationItem] setTitleView:searchBar];
    searchBar.placeholder = @"Search";
    searchBar.barTintColor = [UIColor lightGrayColor];
    searchBar.tintColor = [UIColor colorWithRed:0.855 green:0.243 blue:0.251 alpha:1];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    //[self.refreshControl addTarget:self action:@selector(refresh) forControlEvents:UIControlEventValueChanged];
    //[self refresh];

    
    /*
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 41.0)];
	[self.view addSubview:searchBar];
    searchBar.showsCancelButton = NO;
    searchBar.placeholder = @"Search";
    [searchBar setDelegate:self];
    self.searchDisplayController.displaysSearchBarInNavigationBar = YES;
    searchBar.barTintColor = [UIColor lightGrayColor];
    searchBar.tintColor = [UIColor colorWithRed:0.855 green:0.243 blue:0.251 alpha:1];
     */
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [self retrieveData];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    self.activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    self.activityIndicatorView.hidesWhenStopped = YES;
    
    [self.mainTableView reloadData];

    }

//SÖK DELEGATE METHODS
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
	[searchBar becomeFirstResponder];
	[searchBar setShowsCancelButton:YES animated:YES];
}
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
	[searchBar resignFirstResponder];
	[searchBar setShowsCancelButton:NO animated:YES];
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
	[searchBar resignFirstResponder];
	[searchBar setShowsCancelButton:NO animated:YES];
    searchQuery = searchBar.text;
    [self retrieveData];
    [self.mainTableView reloadData];
}
- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar {
	[searchBar resignFirstResponder];
	[searchBar setShowsCancelButton:NO animated:YES];
}

//TABLE
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return resultArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    
    //cell.textLabel.text = [NSString stringWithFormat:@"Cell %d", indexPath.row];
    
    //Retrieve the current city object for use with this indexPath.row
    Movie * selectedMovie = [resultArray objectAtIndex:indexPath.row];
    
    //cell.textLabel.text = resultArray[indexPath.row];
    cell.textLabel.text = selectedMovie.movieName;
    cell.detailTextLabel.text = selectedMovie.movieRelease;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

//TABLE DELEGATE METHODS
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    RateViewController * dvc = [[RateViewController alloc]init];
    
    //Retrieve the current selected movie
    Movie* selectedMovie = [resultArray objectAtIndex:indexPath.row];
    dvc.movieID = selectedMovie.movieID;
    dvc.movieName = selectedMovie.movieName;
    dvc.movieRelease = selectedMovie.movieRelease;
    dvc.movieName = selectedMovie.movieName;
    dvc.movieGenre = selectedMovie.movieGenre;
    dvc.movieRuntime = selectedMovie.movieRuntime;
    dvc.movieBackground = selectedMovie.movieBackgroundImageURL;

    NSLog(@"%@", selectedMovie.movieName);
    
    [self.navigationController pushViewController:dvc animated:YES];
}

//HÄMTA DATA
- (void) retrieveData
{
    NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", getDataURL, @"indiana+jones"]];
    NSData * data = [NSData dataWithContentsOfURL:url];
    
    json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    
    resultArray = [[NSMutableArray alloc]init];
    movieArray = [[NSMutableArray alloc] init];
    movieArray = [json objectForKey:@"results"];

    NSLog(@"%@", movieArray);
    
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
    }
    */
     
    NSLog(@"%@", resultArray);
    
    [self.mainTableView reloadData];
}

@end
