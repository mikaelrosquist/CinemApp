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

@synthesize scrollView, activityTable, activityTableCell, movieTitle, posterArray, titleArray, yearArray, ratingsArray, likedArray, likeModel, user, oneMovie, userSet, movieInfoFetched;


NSDate *timeStamp;
NSDate *now;
NSCalendar *gregorian;
NSInteger months, days, hours, minutes, seconds;

NSString *ten = @"/10";
NSString *rateID;
NSString *rateString;
NSString *timeString;
NSString *movieYear;
NSString *movieTitle;
NSString *movieID;
NSString *username;
NSString *comment;
NSNumber *rating;

NSDictionary *json;
NSData *moviePoster;
CGFloat tableHeight;

NSMutableDictionary* sendingObject;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        oneMovie = NO;
        userSet = NO;
        
        [self commonInit];
        likeModel = [[LikeModel alloc]init];

        activityTable.tableView.scrollEnabled=YES;
        [activityTable.tableView setHidden:YES];
        [DejalActivityView activityViewForView:self.view].showNetworkActivityIndicator = YES;
        
        CGRect bounds = self.scrollView.bounds;
        self.activityTable.tableView.frame = bounds;
        self.activityTable.tableView.contentInset = UIEdgeInsetsMake(64.0f, 0.0f, 50.0f, 0.0f);
        self.activityTable.tableView.ScrollIndicatorInsets = UIEdgeInsetsMake(64.0f, 0.0f, 50.0f, 0.0f);
        self.activityTable.refreshControl = [[UIRefreshControl alloc] init];
        [self.activityTable.refreshControl addTarget:self action:@selector(refresh) forControlEvents:UIControlEventValueChanged];
        
    }
    return self;
}

- (id)initWithOneMovie:(NSString *)incomingID :(NSString *)incomingTitle :(NSData *)incomingPoster :(CGFloat)backDropImageHeight
{
    if (self) {
        oneMovie = YES;
        userSet = NO;
        movieID = incomingID;
        movieTitle = incomingTitle;
        moviePoster = incomingPoster;
        //CGFloat yParameter = backDropImageHeight;
        [self commonInit];
        
        NSLog(@"initWithOneMovie MOVIEID: %@", movieID);
//        NSLog(@"TableHeight: %f", tableHeight);
//        NSLog(@"Scroll Height: %f", scrollView.frame.size.height);
        
    }
    return self;
}

- (id)initWithUser:(PFUser *)incomingUser{
    if(self){
        user = incomingUser;
        oneMovie = NO;
        userSet = YES;
        [self commonInit];
        activityTable.tableView.scrollEnabled=NO;
        NSLog(@"initWithUser");
    }
    return self;
}

//Gemensam init
- (void) commonInit {
    
    movieInfoFetched = NO;
    [self retrieveUserRatings];
    scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height)];
    activityTable = [[UITableViewController alloc]init];
    activityTable.tableView.dataSource = self;
    activityTable.tableView.delegate = self;
    self.activityTable.tableView.backgroundColor = [UIColor colorWithRed:0.96 green:0.96 blue:0.94 alpha:1];
    
    [scrollView addSubview:activityTable.tableView];
    [self.view addSubview:scrollView];
    
}

-(void)refresh {
    oneMovie = NO;
    userSet = NO;
    [self retrieveUserRatings];
    [posterArray removeAllObjects];
    [titleArray removeAllObjects];
    [yearArray removeAllObjects];
    [ratingsArray removeAllObjects];
}

- (void)viewDidLoad
{
    NSLog(@"ViewDidLoad");
    gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    [super viewDidLoad];
    [self.activityTable.tableView reloadData];
    // [activityTable setFrame:CGRectMake(activityTable.frame.origin.x, activityTable.frame.origin.y, 320, activityTable.contentSize.height)];
    activityTable.tableView.backgroundColor = [UIColor colorWithRed:0.96 green:0.96 blue:0.94 alpha:1];
    activityTable.tableView.separatorColor = [UIColor colorWithRed:0.96 green:0.96 blue:0.94 alpha:1];
    self.edgesForExtendedLayout = UIRectEdgeAll;
    self.extendedLayoutIncludesOpaqueBars=YES;
    self.automaticallyAdjustsScrollViewInsets=YES;
    
    posterArray = [[NSMutableArray alloc]init];
    titleArray = [[NSMutableArray alloc]init];
    yearArray = [[NSMutableArray alloc]init];
    ratingsArray = [[NSMutableArray alloc]init];
    
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(likePost:)
     name:[NSString stringWithFormat:@"test"]
     object:sendingObject];
    
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated{
    [self.activityTable.tableView reloadData];
    [self.scrollView reloadInputViews];
    //self.activityTable.tableView.frame = CGRectMake(0, 0, 320, tableHeight*148);
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
    //return activityTableCell.commentButton.frame.origin.y+activityTableCell.commentButton.frame.size.height+40;
    return 240;
}
/*
 -(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
 return 50;
 }
 
 //Hit kan vi flytta användarnamn och tidsstämpel till sedan, som i Instagram.
 - (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
 return @"ANVÄNDARINFO";
 }*/

- (ActivityTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"activityTableCell";
    
    activityTableCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(activityTableCell == nil) {
        activityTableCell = [[ActivityTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                                         reuseIdentifier:cellIdentifier];
        activityTableCell.backgroundColor = activityTable.tableView.backgroundColor;
        //NSLog(@"ny cell");
    }
    
    //Alternera mellan två bakgrundsfärger för att avgränsa celler
    //if((indexPath.row % 2) == 0)
    //    activityTableCell.backgroundColor = activityTable.backgroundColor;
    //else
    //    activityTableCell.backgroundColor = [UIColor lightGrayColor];
    
    if(indexPath.row <= ratingsArray.count){
        
        rateID = [[ratingsArray objectAtIndex:indexPath.row] valueForKey:@"objectId"];
        username = [[ratingsArray objectAtIndex:indexPath.row] valueForKey:@"user"];
        comment = [[ratingsArray objectAtIndex:indexPath.row] objectForKey:@"comment"];
        rating = [[ratingsArray objectAtIndex:indexPath.row] objectForKey:@"rating"];
        movieID = [[ratingsArray objectAtIndex:indexPath.row] objectForKey:@"movieId"];
        timeStamp = [[ratingsArray objectAtIndex:indexPath.row] createdAt];
        [self formatTime:timeStamp];
        activityTableCell.rateID = rateID;
        activityTableCell.toUserID = [[ratingsArray objectAtIndex:indexPath.row] valueForKey:@"userId"];;
        
        
        if(likedArray.count > 0 && [likedArray objectAtIndex:indexPath.row] == [NSNumber numberWithBool:1]){
            [activityTableCell.likeButton setTitle:@"Liked" forState:UIControlStateNormal];
            [activityTableCell.likeButton setImage: [UIImage imageNamed:@"likeBtn-1"] forState:UIControlStateNormal];
            [activityTableCell.likeButton setBackgroundColor:[UIColor colorWithRed:0.769 green:0.769 blue:0.769 alpha:1]];
            [activityTableCell.likeButton setTitleEdgeInsets:UIEdgeInsetsMake(0.0, -30.0, 0.0, 0.0)];

        }else{
            

        }
        
        
        
        //if(!oneMovie)
        //  [self retrieveMovieInfo];
        
        if (titleArray.count > 0){
            //if([likeModel isLiking:[PFUser currentUser] :rateID])
            //    activityTableCell.isLiked = YES;
            
            movieTitle = [titleArray objectAtIndex:indexPath.row];
            movieYear = [yearArray objectAtIndex:indexPath.row];
            activityTableCell.rateID = rateID;
            //[activityTableCell updateButton];
            
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
                activityTableCell.rateStar.frame = CGRectMake(activityTableCell.posterView.frame.origin.x+10, activityTableCell.posterView.frame.origin.y+activityTableCell.posterView.frame.size.height+10, 37.5, 37.5);
            else
                activityTableCell.rateStar.frame = CGRectMake(activityTableCell.posterView.frame.origin.x+10, activityTableCell.commentLabel.frame.origin.y+activityTableCell.commentLabel.frame.size.height+10, 37.5, 37.5);
            
            //Betyget anpassas efter stjärnan
            rateString = [NSString stringWithFormat:@"%@", rating];
            activityTableCell.ratingLabel.text = [NSString stringWithFormat:@"%@", rateString]; //lägg till stringen "ten" för att få "[betyg]/10".
            activityTableCell.ratingLabel.frame = CGRectMake(activityTableCell.rateStar.frame.origin.x+activityTableCell.rateStar.frame.size.width+5, activityTableCell.rateStar.frame.origin.y+5, 0, 0);
            [activityTableCell.ratingLabel sizeToFit];
            /*
            NSMutableAttributedString *rateOfTen = [[NSMutableAttributedString alloc] initWithAttributedString: activityTableCell.ratingLabel.attributedText];
            [rateOfTen addAttribute: NSForegroundColorAttributeName value: [UIColor grayColor] range: NSMakeRange([rateString length]+1, 3)];
            [rateOfTen addAttribute: NSFontAttributeName value: [UIFont fontWithName: @"HelveticaNeue-Light" size: 14.0] range: NSMakeRange([rateString length], 3)];
            [activityTableCell.ratingLabel setAttributedText: rateOfTen];
            */
            
            //Användare
            activityTableCell.userLabel.text = username;
            activityTableCell.userImageView.image = [UIImage imageNamed:@"profilePicPlaceHolder"];
            activityTableCell.tag = indexPath.row;
            
            //Tid
            activityTableCell.timeLabel.text = [self formatTime:timeStamp];
            activityTableCell.posterView.image = [UIImage imageWithData:[posterArray objectAtIndex:indexPath.row]];
            
            //Buttons anpassas efter stjärna och betyg

            activityTableCell.likeButton.frame = CGRectMake(activityTableCell.ratingLabel.frame.origin.x+45, activityTableCell.ratingLabel.frame.origin.y+5, 65, 25);
            activityTableCell.commentButton.frame = CGRectMake(activityTableCell.likeButton.frame.origin.x+activityTableCell.likeButton.frame.size.width+10, activityTableCell.ratingLabel.frame.origin.y+5, 90, 25);
            
            //Vet inte om detta bidrar till bättre performance..
            //activityTableCell.layer.shouldRasterize = YES;
            //activityTableCell.layer.rasterizationScale = [UIScreen mainScreen].scale;
            
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
/*
 - (void)updateButtons{
 
 for(int i = 0; i < ratingsArray.count; i++){
 BOOL tmp = [likeModel isLiking:[PFUser currentUser] :[[ratingsArray objectAtIndex:i] valueForKey:@"objectId"]];
 [likedArray addObject:[NSNumber numberWithBool:tmp]];
 }
 
 PFQuery *query = [PFQuery queryWithClassName:@"Like"];
 [query whereKey:@"userId" equalTo:[PFUser currentUser].objectId];
 [query whereKey:@"ratingId" equalTo:rateID];
 
 [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
 if (objects.count > 0){
 [activityTableCelllikeButton setTitle:@"Liked" forState:UIControlStateNormal];
 likeButton.backgroundColor = [UIColor greenColor];
 }else{
 [likeButton setTitle:@"Like" forState:UIControlStateNormal];
 likeButton.backgroundColor = [UIColor colorWithRed:0.855 green:0.243 blue:0.251 alpha:1];
 }
 }];
 }
 */
- (void)retrieveUserRatings{
    //    ratingsArray = [[NSArray alloc]init];
    //    ratingsArray = nil;
    PFQuery *movieQuery = [PFQuery queryWithClassName:@"Rating"];
    movieQuery.limit = 10;
    
    likedArray = [[NSMutableArray alloc]init];
    
    if(oneMovie){
        [movieQuery whereKey:@"movieId" equalTo:[NSString stringWithFormat:@"%@", movieID]];
        NSLog(@"oneMovieQuery");
    }
    else if(userSet){
        [movieQuery whereKey:@"userId" equalTo:[NSString stringWithFormat:@"%@", user.objectId]];
        NSLog(@"userQuery");
    }
    [movieQuery orderByDescending:@"createdAt"];
    [movieQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            
            ratingsArray = (NSMutableArray *)objects;
            tableHeight = [ratingsArray count];
            
            //NSLog(@"HÄMTAT: %@", ratingsArray);
            
            //Hämtar filminfo och laddar om viewn när ratings hämtats.
            activityTableCell = nil;
            [self retrieveMovieInfo];
            [[self activityTable].tableView reloadData];
            [self.activityTable.refreshControl endRefreshing];
            [DejalActivityView removeView];
            [self getLikes];
        }
        
    }];
    
    
    
    
}

-(void)getLikes{
    
    for(int i = 0; i < ratingsArray.count; i++){
        BOOL tmp = [likeModel isLiking:[PFUser currentUser] :[[ratingsArray objectAtIndex:i] valueForKey:@"objectId"]];
        [likedArray addObject:[NSNumber numberWithBool:tmp]];
        [[self activityTable].tableView reloadData];
    }
    NSLog(@"%@", likedArray);
}

-(void)retrieveMovieInfo{
    
    NSString *posterPath;
    NSString *posterString;
    NSURL *posterURL;
    NSURL *url;
    NSData *data;
    
    //NSLog(@"RETRIEVED MOVIE ID: %@", movieID);
    for(int i=0; i < [ratingsArray count]; i++){
        
        //NSLog(@"RETRIEVING MOVIE");
        
        url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@", getDataURL, [[ratingsArray objectAtIndex:i] objectForKey:@"movieId"], api_key]];
        data = [NSData dataWithContentsOfURL:url];
        json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        
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
        
    }
    [activityTable.tableView setHidden:NO];
    [DejalActivityView removeView];
}

- (NSString *)formatTime:(NSDate *)timeStamp{
    now = [NSDate date];
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

- (void) likePost:(NSNotification *)notification{
    NSDictionary* userInfo = notification.userInfo;
    NSString *ratingID = [userInfo objectForKey:@"rating"];
    [likeModel addLike:[PFUser currentUser] :[NSString stringWithFormat:@"%@", ratingID]:[userInfo objectForKey:@"toUser"]];
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