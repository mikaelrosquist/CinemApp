//
//  ViewController.m
//  JSONiOS
//
//  Created by Kurup, Vishal on 4/14/13.
//  Copyright (c) 2013 conkave. All rights reserved.
//

#import "RateSearchViewController.h"

@interface RateSearchViewController ()

@end

#define getDataURL @"http://api.themoviedb.org/3/search/movie?api_key=2da45d86a9897bdf7e7eab86aa0485e3&query="
#define searchQuery @"Indiana+Jones"

@implementation RateSearchViewController
@synthesize json, resultArray, mainTableView, latestLoans;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = searchQuery;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor whiteColor];
    [self retrieveData];
    [self.mainTableView reloadData];
}

- (void)viewWillAppear:(BOOL)animated{
    //Färg på navigationBaren
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;

}

#pragma mark - UITableView Datasource

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

#pragma mark - UITableView Delegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    RateViewController * dvc = [[RateViewController alloc]init];
    
    //Retrieve the current selected city
    
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


#pragma mark - Methods
- (void) retrieveData
{
    NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", getDataURL, searchQuery]];
    NSData * data = [NSData dataWithContentsOfURL:url];
    
    json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    
    resultArray = [[NSMutableArray alloc]init];
    latestLoans = [[NSMutableArray alloc] init];
    latestLoans = [json objectForKey:@"results"];

    NSLog(@"%@", latestLoans);
    
    for (int i = 0; i < latestLoans.count; i++)
    {
        //Create city object
        NSString * mID = [[latestLoans objectAtIndex:i] valueForKey:@"id"];
        NSString * mName = [[latestLoans objectAtIndex:i] valueForKey:@"original_title"];
        NSString * mRelease = [[latestLoans objectAtIndex:i] valueForKey:@"release_date"];
        NSString * mGenre = @"N/A";
        NSString * mRuntime = @"N/A";
        NSString * mBackground = [[latestLoans objectAtIndex:i] valueForKey:@"backdrop_path"];
        Movie* myCity = [[Movie alloc]initWithMovieID:mID andMovieName: mName andMovieRelease:mRelease andMovieGenre:mGenre andMovieRuntime:mRuntime andMovieBackgroundImageURL:mBackground];
        //Add our city object to our cities array
        [resultArray addObject:myCity];
    }
    
    NSLog(@"%@", resultArray);
    
    [self.mainTableView reloadData];
    
    
}

@end
