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

@synthesize activityTable, activityTableCell, movieTitle;

NSString *movieTitle;
NSString *movieID;
NSDictionary *json;
NSArray *ratingsArray;
NSData *moviePoster;
CGFloat tableHeight;
BOOL oneMovie = NO;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self retrieveUserRatings];
        
        activityTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, 320, tableHeight*148+20)];
        activityTable.dataSource = self;
        activityTable.delegate = self;
        
        [self.view addSubview:activityTable];
    }
    return self;
}

- (id)initWithOneMovie:(NSString *)incomingID :(NSString *)incomingTitle :(NSData *)incomingPoster :(CGFloat)backDropImageHeight
{
    if (self) {
        oneMovie = TRUE;
        movieID = incomingID;
        movieTitle = incomingTitle;
        moviePoster = incomingPoster;
        CGFloat yParameter = backDropImageHeight;
        
        [self retrieveUserRatings];
        NSLog(@"initWithOneMovie MOVIEID: %@", movieID);
        activityTable = [[UITableView alloc]initWithFrame:CGRectMake(0, yParameter+50, 320, tableHeight*148+20)];
        activityTable.dataSource = self;
        activityTable.delegate = self;
        
        [self.view addSubview:activityTable];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.activityTable reloadData];
   // [activityTable setFrame:CGRectMake(activityTable.frame.origin.x, activityTable.frame.origin.y, 320, activityTable.contentSize.height)];
    self.edgesForExtendedLayout = UIRectEdgeAll;
    self.extendedLayoutIncludesOpaqueBars=YES;
    self.automaticallyAdjustsScrollViewInsets=YES;
    
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated{
    [[self activityTable] reloadData];
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
        NSNumber *rating = [[ratingsArray objectAtIndex:indexPath.row] objectForKey:@"rating"];
        movieID = [[ratingsArray objectAtIndex:indexPath.row] objectForKey:@"movieId"];
        
        if(!oneMovie)
            [self retrieveMovieInfo:movieID];
        
        NSLog(@"Betyg: %@",rating);
        
        UILabel *movieTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(110, 5, 100, 30)];
        movieTitleLabel.text = movieTitle;
        UITextView *commentView = [[UITextView alloc]initWithFrame:CGRectMake(110, 40, 240, 30)];
        commentView.text = comment;
        commentView.editable = NO;
        [commentView setContentInset:UIEdgeInsetsMake(-10, -5, 10, 5)];
        UILabel *userLabel = [[UILabel alloc]initWithFrame:CGRectMake(110, 80, 100, 30)];
        userLabel.text = username;
        UILabel *ratingLabel = [[UILabel alloc]initWithFrame:CGRectMake(280, 80, 30, 30)];
        ratingLabel.text = [NSString stringWithFormat:@"%@", rating];
        
        UIImageView *posterView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 90, 128)];
        posterView.image = [UIImage imageWithData:moviePoster];
        
        [activityTableCell.contentView addSubview:userLabel];
        [activityTableCell.contentView addSubview:movieTitleLabel];
        [activityTableCell.contentView addSubview:ratingLabel];
        [activityTableCell.contentView addSubview:commentView];
        [activityTableCell.contentView addSubview:posterView];
    }
    
    return activityTableCell;
}


- (void)retrieveUserRatings{
    
    ratingsArray = [[NSArray alloc]init];
    
    PFQuery *movieQuery = [PFQuery queryWithClassName:@"Rating"];
    movieQuery.limit = 10;
    
    if(movieID != NULL) //Måste avkommenteras för att newsfeed ska funka
    [movieQuery whereKey:@"movieId" equalTo:[NSString stringWithFormat:@"%@", movieID]];

    [movieQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            
            ratingsArray = objects;
            tableHeight = [ratingsArray count];
                
            [[self activityTable] reloadData];
            
            NSLog(@"HÄMTAT: %@", ratingsArray);
            
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
    
}


-(void)retrieveMovieInfo:(NSString *)movieID{
    
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