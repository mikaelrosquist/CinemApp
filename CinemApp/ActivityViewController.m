//
//  ActivityViewController.m
//  CinemApp
//
//  Created by mikael on 29/04/14.
//  Copyright (c) 2014 Rosquist Östlund. All rights reserved.
//

#import "ActivityViewController.h"

#define getDataURL @"http://api.themoviedb.org/3/movie/"
#define api_key @"?api_key=2da45d86a9897bdf7e7eab86aa0485e3"

@interface ActivityViewController ()

@end

@implementation ActivityViewController

@synthesize activityTable, activityTableCell;

NSDictionary *json;
NSArray *ratingsArray;
NSData *moviePoster;
NSString *movieTitle;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self retrieveMovieRatings];
        
        activityTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, 320, 600)];
        activityTable.dataSource = self;
        activityTable.delegate = self;
        
        [self.view addSubview:activityTable];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.edgesForExtendedLayout = UIRectEdgeAll;
    self.extendedLayoutIncludesOpaqueBars=YES;
    self.automaticallyAdjustsScrollViewInsets=YES;
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
    NSLog(@"numberOfSections");
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [ratingsArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 148;
}

- (ActivityTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //NSLog(@"cellForRowAtIndexPath");
    static NSString *cellIdentifier = @"activityTableCell";
    
    activityTableCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(activityTableCell == nil) {
        activityTableCell = [[ActivityTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                                         reuseIdentifier:cellIdentifier];
        //NSLog(@"ny cell");
    }
    
    if(ratingsArray != 0){
        
        NSString *username = [[ratingsArray objectAtIndex:indexPath.row] valueForKey:@"user"];
        NSString *comment = [[ratingsArray objectAtIndex:indexPath.row] objectForKey:@"comment"];
        NSString *rating = [[ratingsArray objectAtIndex:indexPath.row] objectForKey:@"rating"];
        NSString *movieID = [[ratingsArray objectAtIndex:indexPath.row] objectForKey:@"movieId"];
        
        [self retrieveMovieInfo:movieID];
        
        NSLog(@"Betyg: %@",rating);
        
        UILabel *userLabel = [[UILabel alloc]initWithFrame:CGRectMake(110, 5, 100, 30)];
        userLabel.text = username;
        UILabel *movieTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(110, 40, 100, 30)];
        movieTitleLabel.text = movieTitle;
       // UILabel *ratingLabel = [[UILabel alloc]initWithFrame:CGRectMake(110, 5, 30, 30)];
       // ratingLabel.text = rating;
        UITextView *commentView = [[UITextView alloc]initWithFrame:CGRectMake(110, 70, 240, 30)];
        commentView.text = comment;
        [commentView setContentInset:UIEdgeInsetsMake(-10, -5, 10, 5)];
        
        UIImageView *posterView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 90, 128)];
        posterView.image = [UIImage imageWithData:moviePoster];
        
        [activityTableCell.contentView addSubview:userLabel];
        [activityTableCell.contentView addSubview:movieTitleLabel];
        //[activityTableCell.contentView addSubview:ratingLabel];
        [activityTableCell.contentView addSubview:commentView];
        [activityTableCell.contentView addSubview:posterView];
    }
    
    return activityTableCell;
}


- (void)retrieveMovieRatings{
    
    //PFQuery *movieQuery = [PFUser query];
    
    PFQuery *movieQuery = [PFQuery queryWithClassName:@"Rating"];
    //Villkor för senare implementering [query whereKey:@"user" equalTo:@"following"];
    ratingsArray = [[NSArray alloc]init];
    
    movieQuery.limit = 10;
    //searchQuery = [searchQuery lowercaseString];
    
    [movieQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            
            ratingsArray = objects;
            
            [[self activityTable] reloadData];
            
            NSLog(@"HÄMTAT: Sökresultat för %@", ratingsArray);
            
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
    
}


-(void)retrieveMovieInfo:(NSString *)movieID{
    
    //NSString *movieString = (NSString *)movieID;
    
    NSLog(@"MOVIE ID: %@", movieID);
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@", getDataURL, movieID, api_key]];
    NSData *data = [NSData dataWithContentsOfURL:url];
    json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    
    NSLog(@"%@", json);
    
    NSString *posterPath = [json valueForKey:@"poster_path"];
    NSString *posterString = [NSString stringWithFormat:@"https://image.tmdb.org/t/p/w185%@", posterPath];
    NSURL *posterURL = [NSURL URLWithString:posterString];
    moviePoster = [NSData dataWithContentsOfURL:posterURL];
    
    movieTitle = [json valueForKey:@"original_title"];
}


/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end