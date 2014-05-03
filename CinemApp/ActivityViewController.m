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

@synthesize scrollView, activityTable, activityTableCell, movieTitle;

NSString *ten = @"/10";
NSString *rateString;

NSMutableArray *posterArray;
NSMutableArray *titleArray;
NSMutableArray *yearArray;

NSString *movieYear;
NSString *movieTitle;
NSString *movieID;
NSString *username;
NSString *comment;
NSNumber *rating;
NSDictionary *json;
NSArray *ratingsArray;
NSData *moviePoster;
CGFloat tableHeight;
BOOL oneMovie = NO;
BOOL movieInfoFetched = NO;

UILabel *movieTitleLabel;
UILabel *userLabel;
UITextView *commentView;
UILabel *ratingLabel;
UIImageView *posterView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self retrieveUserRatings];
        
        scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, 320, 520)];
        
        activityTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, 320, 600)];
        activityTable.dataSource = self;
        activityTable.delegate = self;
        activityTable.scrollEnabled=YES;
        
        [scrollView addSubview:activityTable];
        [self.view addSubview:scrollView];
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
    activityTable.backgroundColor = [UIColor colorWithRed:0.96 green:0.96 blue:0.94 alpha:1];
    activityTable.separatorColor = [UIColor colorWithRed:0.96 green:0.96 blue:0.94 alpha:1];
    self.edgesForExtendedLayout = UIRectEdgeAll;
    self.extendedLayoutIncludesOpaqueBars=YES;
    self.automaticallyAdjustsScrollViewInsets=YES;
    
    posterArray = [[NSMutableArray alloc]init];
    titleArray = [[NSMutableArray alloc]init];
    yearArray = [[NSMutableArray alloc]init];
    
    for(int i=0; i < [ratingsArray count]; i++){
        NSLog(@"FORLOOP");
        //[self retrieveMovieInfo:[[ratingsArray objectAtIndex:i] objectForKey:@"movieId"]];
        
    }
    
    
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated{
    [self.activityTable reloadData];
    [self.scrollView reloadInputViews];
    self.activityTable.frame = CGRectMake(0, 0, 320, tableHeight*148);
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
        activityTableCell.backgroundColor = activityTable.backgroundColor;
        //NSLog(@"ny cell");
    }
    
    //Alternera mellan två bakgrundsfärger för att avgränsa celler
    //if((indexPath.row % 2) == 0)
    //    activityTableCell.backgroundColor = activityTable.backgroundColor;
    //else
    //    activityTableCell.backgroundColor = [UIColor lightGrayColor];
    
    if(ratingsArray != 0){
        
        username = [[ratingsArray objectAtIndex:indexPath.row] valueForKey:@"user"];
        comment = [[ratingsArray objectAtIndex:indexPath.row] objectForKey:@"comment"];
        rating = [[ratingsArray objectAtIndex:indexPath.row] objectForKey:@"rating"];
        movieID = [[ratingsArray objectAtIndex:indexPath.row] objectForKey:@"movieId"];
        
        //if(!oneMovie)
          //  [self retrieveMovieInfo];
        
        if (titleArray.count > 0){
            
             NSLog(@"Betyg: %@",rating);
            
            movieTitle = [titleArray objectAtIndex:indexPath.row];
            movieYear = [yearArray objectAtIndex:indexPath.row];
           
            //Filmtiteln
            activityTableCell.movieTitleLabel.text = [NSString stringWithFormat:@"%@ %@ ", movieTitle, movieYear];
            activityTableCell.movieTitleLabel.frame = CGRectMake(activityTableCell.posterView.frame.size.width+20, activityTableCell.posterView.frame.origin.y-4, 290-activityTableCell.posterView.frame.size.width, activityTableCell.movieTitleLabel.frame.size.height);
            [activityTableCell.movieTitleLabel sizeToFit];
            NSMutableAttributedString *titleYear = [[NSMutableAttributedString alloc] initWithAttributedString: activityTableCell.movieTitleLabel.attributedText];
            [titleYear addAttribute: NSForegroundColorAttributeName value: [UIColor grayColor] range: NSMakeRange([self.movieTitle length]+1, 6)];
            [titleYear addAttribute: NSFontAttributeName value: [UIFont fontWithName: @"HelveticaNeue-Light" size: 14.0] range: NSMakeRange([movieTitle length]+1, 6)];
            [activityTableCell.movieTitleLabel setAttributedText: titleYear];
            
            //Stjärnan anpassas efter poster och titel
            activityTableCell.rateStar.frame = CGRectMake(activityTableCell.posterView.frame.size.width+20, activityTableCell.movieTitleLabel.frame.size.height+10, 30, 30);
            
            //Betyget anpassas efter poster, stjärna och titel
            rateString = [NSString stringWithFormat:@"%@", rating];
            activityTableCell.ratingLabel.text = [NSString stringWithFormat:@"%@%@ ", rateString, ten];
            activityTableCell.ratingLabel.frame = CGRectMake(activityTableCell.posterView.frame.size.width+activityTableCell.rateStar.frame.size.width+30, activityTableCell.movieTitleLabel.frame.size.height+15, 80, 22);
            NSMutableAttributedString *rateOfTen = [[NSMutableAttributedString alloc] initWithAttributedString: activityTableCell.ratingLabel.attributedText];
            [rateOfTen addAttribute: NSForegroundColorAttributeName value: [UIColor blackColor] range: NSMakeRange([rateString length]+1, 3)];
            [rateOfTen addAttribute: NSFontAttributeName value: [UIFont fontWithName: @"HelveticaNeue-Light" size: 14.0] range: NSMakeRange([rateString length], 3)];
            [activityTableCell.ratingLabel setAttributedText: rateOfTen];

            
            
            NSLog(@"%@", activityTableCell.movieTitleLabel);
            
            activityTableCell.commentView.text = comment;
            activityTableCell.commentView.editable = NO;
            activityTableCell.commentView.backgroundColor = activityTableCell.backgroundColor;
            [activityTableCell.commentView setContentInset:UIEdgeInsetsMake(-10, -5, 10, 5)];
            //[activityTableCell.commentView sizeToFit]; //strular lite, tror det har med att denna körs innnan kommentaren hämtats från parse.
            
            activityTableCell.userLabel.text = username;
            
            activityTableCell.posterView.image = [UIImage imageWithData:[posterArray objectAtIndex:indexPath.row]];
            
            //Vet inte om detta bidrar till bättre performance..
            activityTableCell.layer.shouldRasterize = YES;
            activityTableCell.layer.rasterizationScale = [UIScreen mainScreen].scale;
            
            //[self.activityTableCell.contentView addSubview:activityTableCell.userLabel];
            [self.activityTableCell.contentView addSubview:activityTableCell.movieTitleLabel];
            [self.activityTableCell.contentView addSubview:activityTableCell.rateStar];
            [self.activityTableCell.contentView addSubview:activityTableCell.ratingLabel];
            //  [self.contentView addSubview:commentView];
            [self.activityTableCell.contentView addSubview:activityTableCell.posterView];
        }
    }
    
    return activityTableCell;
}


- (void)prepareForReuse
{
    
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
            
            NSLog(@"HÄMTAT: %@", ratingsArray);
            
            //Hämtar filminfo och laddar om viewn när ratings hämtats.
            [self retrieveMovieInfo];
            [[self activityTable] reloadData];
            
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}

-(void)retrieveMovieInfo{
    
    //NSLog(@"RETRIEVED MOVIE ID: %@", movieID);
    for(int i=0; i < [ratingsArray count]; i++){
        
        NSLog(@"RETRIEVING MOVIES");
        
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@", getDataURL, [[ratingsArray objectAtIndex:i] objectForKey:@"movieId"], api_key]];
        NSData *data = [NSData dataWithContentsOfURL:url];
        json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        
        NSLog(@"%@", json);
        
        NSString *posterPath = [json valueForKey:@"poster_path"];
        NSString *posterString = [NSString stringWithFormat:@"https://image.tmdb.org/t/p/w90%@", posterPath];
        NSURL *posterURL = [NSURL URLWithString:posterString];
        [posterArray addObject:[NSData dataWithContentsOfURL:posterURL]];
        
        [titleArray addObject:[json valueForKey:@"original_title"]];
        movieYear = [NSString stringWithFormat:@"(%@)", [[json valueForKey:@"release_date"] substringToIndex:4]];
        if ([movieYear isEqualToString:@""])
            movieYear = @"xxxx-xx-xx";
        [yearArray addObject:movieYear];
        
        movieInfoFetched = YES;

    }
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