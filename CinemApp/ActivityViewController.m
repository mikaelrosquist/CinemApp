//
//  ActivityViewController.m
//  CinemApp
//
//  Created by mikael on 29/04/14.
//  Copyright (c) 2014 Rosquist Östlund. All rights reserved.
//

#import "ActivityViewController.h"
#import "DejalActivityView.h"

#define getDataURL @"http://api.themoviedb.org/3/movie/"
#define api_key @"?api_key=2da45d86a9897bdf7e7eab86aa0485e3"

@interface ActivityViewController ()

@end

@implementation ActivityViewController

@synthesize scrollView, activityTable, activityTableCell, movieTitle;

NSDate *timeStamp;
NSDate *now;
NSCalendar *gregorian;
NSInteger months, days, hours, minutes, seconds;

NSMutableArray *posterArray;
NSMutableArray *titleArray;
NSMutableArray *yearArray;

NSString *ten = @"/10";
NSString *rateString;
NSString *timeString;
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

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self retrieveUserRatings];
        
        scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height)];
        activityTable = [[UITableView alloc]init];
        activityTable.dataSource = self;
        activityTable.delegate = self;
        activityTable.scrollEnabled=YES;
        [scrollView addSubview:activityTable];
        [self.view addSubview:scrollView];
        
        [activityTable setHidden:YES];
        [DejalActivityView activityViewForView:self.view].showNetworkActivityIndicator = YES;
        self.activityTable.backgroundColor = [UIColor colorWithRed:0.96 green:0.96 blue:0.94 alpha:1];
        self.activityTable.separatorColor = [UIColor colorWithRed:0.96 green:0.96 blue:0.94 alpha:1];
        self.activityTable.ScrollIndicatorInsets = UIEdgeInsetsMake(64.0f, 0.0f, 50.0f, 0.0f);
        self.activityTable.contentInset = UIEdgeInsetsMake(64.0f, 0.0f, 50.0f, 0.0f);
        CGRect bounds = self.scrollView.bounds;
        self.activityTable.frame = bounds;
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
        NSLog(@"TableHeight: %f", tableHeight);
        activityTable.dataSource = self;
        activityTable.delegate = self;
        
        [self.view addSubview:activityTable];
    }
    return self;
}

- (void)viewDidLoad
{
    
    gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    now = [NSDate date];
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
    NSLog(@"CELLHEIGHT: %f", activityTableCell.commentButton.frame.origin.y+activityTableCell.commentButton.frame.size.height+40);
    //return activityTableCell.commentButton.frame.origin.y+activityTableCell.commentButton.frame.size.height+40;
    return 240;
}

- (ActivityTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"cellForRowAtIndexPath");
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
        timeStamp = [[ratingsArray objectAtIndex:indexPath.row] createdAt];
        
        [self formatTime:timeStamp];
        
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
            [titleYear addAttribute: NSFontAttributeName value: [UIFont fontWithName: @"HelveticaNeue-Light" size: 12.0] range: NSMakeRange([movieTitle length]+1, 6)];
            [activityTableCell.movieTitleLabel setAttributedText: titleYear];
            
            //Recension/kommentar anpassas efter poster
            activityTableCell.commentLabel.text = comment;
            activityTableCell.commentLabel.frame = CGRectMake(activityTableCell.posterView.frame.size.width+20, activityTableCell.movieTitleLabel.frame.size.height+activityTableCell.movieTitleLabel.frame.origin.y+5, 290-activityTableCell.posterView.frame.size.width, 80);
            [activityTableCell.commentLabel sizeToFit];
            
            //Stjärnan anpassas efter poster och kommentar
            if(activityTableCell.commentLabel.frame.origin.y+activityTableCell.commentLabel.frame.size.height < activityTableCell.posterView.frame.origin.y+activityTableCell.posterView.frame.size.height)
                activityTableCell.rateStar.frame = CGRectMake(activityTableCell.posterView.frame.origin.x+20, activityTableCell.posterView.frame.origin.y+activityTableCell.posterView.frame.size.height+10, 30, 30);
            else
                activityTableCell.rateStar.frame = CGRectMake(activityTableCell.posterView.frame.origin.x+20, activityTableCell.commentLabel.frame.origin.y+activityTableCell.commentLabel.frame.size.height+10, 30, 30);
            
            //Betyget anpassas efter stjärnan
            rateString = [NSString stringWithFormat:@"%@", rating];
            activityTableCell.ratingLabel.text = [NSString stringWithFormat:@"%@%@ ", rateString, ten];
            activityTableCell.ratingLabel.frame = CGRectMake(activityTableCell.rateStar.frame.origin.x+activityTableCell.rateStar.frame.size.width+5, activityTableCell.rateStar.frame.origin.y+5, 55, 22);
            NSMutableAttributedString *rateOfTen = [[NSMutableAttributedString alloc] initWithAttributedString: activityTableCell.ratingLabel.attributedText];
            [rateOfTen addAttribute: NSForegroundColorAttributeName value: [UIColor grayColor] range: NSMakeRange([rateString length]+1, 3)];
            [rateOfTen addAttribute: NSFontAttributeName value: [UIFont fontWithName: @"HelveticaNeue-Light" size: 14.0] range: NSMakeRange([rateString length], 3)];
            [activityTableCell.ratingLabel setAttributedText: rateOfTen];
            
            //NSLog(@"%@", activityTableCell.movieTitleLabel);
            
            //Användare
            activityTableCell.userLabel.text = username;
            activityTableCell.userImageView.image = [UIImage imageNamed:@"profilePicPlaceHolder"];
            
            //Tid
            activityTableCell.timeLabel.text = [self formatTime:timeStamp];
            activityTableCell.posterView.image = [UIImage imageWithData:[posterArray objectAtIndex:indexPath.row]];
            
            //Buttons anpassas efter stjärna och betyg
            activityTableCell.likeButton.frame = CGRectMake(activityTableCell.ratingLabel.frame.origin.x+activityTableCell.ratingLabel.frame.size.width+5, activityTableCell.ratingLabel.frame.origin.y, 50, 25);
            activityTableCell.commentButton.frame = CGRectMake(activityTableCell.likeButton.frame.origin.x+activityTableCell.likeButton.frame.size.width+10, activityTableCell.ratingLabel.frame.origin.y, 90, 25);
            
            //Vet inte om detta bidrar till bättre performance..
            activityTableCell.layer.shouldRasterize = YES;
            activityTableCell.layer.rasterizationScale = [UIScreen mainScreen].scale;
            
            [self.activityTableCell.contentView addSubview:activityTableCell.userImageView];
            [self.activityTableCell.contentView addSubview:activityTableCell.userLabel];
            [self.activityTableCell.contentView addSubview:activityTableCell.timeLabel];
            [self.activityTableCell.contentView addSubview:activityTableCell.movieTitleLabel];
            [self.activityTableCell.contentView addSubview:activityTableCell.rateStar];
            [self.activityTableCell.contentView addSubview:activityTableCell.ratingLabel];
            [self.activityTableCell.contentView addSubview:activityTableCell.commentLabel];
            [self.activityTableCell.contentView addSubview:activityTableCell.posterView];
            [self.activityTableCell.contentView addSubview:activityTableCell.commentButton];
            [self.activityTableCell.contentView addSubview:activityTableCell.likeButton];
        }
    }
    self.activityTableCell.selectionStyle = UITableViewCellSelectionStyleNone;
    return activityTableCell;
}


- (void)retrieveUserRatings{
    
    ratingsArray = [[NSArray alloc]init];
    
    PFQuery *movieQuery = [PFQuery queryWithClassName:@"Rating"];
    movieQuery.limit = 10;
    
    if(oneMovie) //Måste avkommenteras för att newsfeed ska funka
        [movieQuery whereKey:@"movieId" equalTo:[NSString stringWithFormat:@"%@", movieID]];
    
    [movieQuery orderByDescending:@"createdAt"];
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
    
    NSString *posterPath;
    NSString *posterString;
    NSURL *posterURL;
    
    //NSLog(@"RETRIEVED MOVIE ID: %@", movieID);
    for(int i=0; i < [ratingsArray count]; i++){
        
        NSLog(@"RETRIEVING MOVIE");
        
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@", getDataURL, [[ratingsArray objectAtIndex:i] objectForKey:@"movieId"], api_key]];
        NSData *data = [NSData dataWithContentsOfURL:url];
        json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        
        //NSLog(@"%@", json);
        
        posterPath = [json valueForKey:@"poster_path"];
        posterString = [NSString stringWithFormat:@"https://image.tmdb.org/t/p/w90%@", posterPath];
        posterURL = [NSURL URLWithString:posterString];
        [posterArray addObject:[NSData dataWithContentsOfURL:posterURL]];
        
        [titleArray addObject:[json valueForKey:@"original_title"]];
        movieYear = [NSString stringWithFormat:@"(%@)", [[json valueForKey:@"release_date"] substringToIndex:4]];
        if ([movieYear isEqualToString:@""])
            movieYear = @"xxxx-xx-xx";
        [yearArray addObject:movieYear];
        movieInfoFetched = YES;
        [activityTable setHidden:NO];
        [DejalActivityView removeView];

    }
}

- (NSString *)formatTime:(NSDate *)timeStamp{
    
    unsigned int unitFlags = NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents *comps = [gregorian components:unitFlags fromDate:timeStamp  toDate:now  options:0];
    
    months = [comps month];
    if(months > 0){
        if (months == 1)
            return [NSString stringWithFormat:@"%ld %@", (long)months, @" month ago"];
        else
            return [NSString stringWithFormat:@"%ld %@", (long)months, @" months ago"];
    }
    days = [comps day];
    if(days > 0){
        if (days == 1)
            return [NSString stringWithFormat:@"%ld %@", (long)days, @" day ago"];
        else
            return [NSString stringWithFormat:@"%ld %@", (long)days, @" days ago"];
    }
    hours = [comps hour];
    if(hours > 0){
        if (hours == 1)
            return [NSString stringWithFormat:@"%ld %@", (long)hours, @" hour ago"];
        else
            return [NSString stringWithFormat:@"%ld %@", (long)hours, @" hours ago"];
    }
    minutes = [comps minute];
    if(minutes > 0){
        if (minutes == 1)
            return [NSString stringWithFormat:@"%ld %@", (long)minutes, @" minute ago"];
        else
            return [NSString stringWithFormat:@"%ld %@", (long)minutes, @" minutes ago"];
    }
    seconds = [comps second];
    if(seconds > 0)
        return [NSString stringWithFormat:@"%ld %@", (long)seconds, @" seconds ago"];
    
    return @"0";
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