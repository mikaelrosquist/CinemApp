//
//  RateViewController.m
//  TabBar
//
//  Created by Teodor Östlund on 2014-02-17.
//  Copyright (c) 2014 Teodor Östlund. All rights reserved.
//

#import "RateViewController.h"
#import "DejalActivityView.h"


#define getDataURL @"http://api.themoviedb.org/3/movie/"
#define api_key @"?api_key=2da45d86a9897bdf7e7eab86aa0485e3"
#define getCreditsURL @"/credits"

//Sätter backgrundsbildens höjd och bredd till statiska värden
static CGFloat backdropImageHeight  = 220.0;
static CGFloat backdropImageWidth  = 320.0;

@interface RateViewController ()

@end

@implementation RateViewController{
    UILabel *movieTitleLabel, *movieGenresLabel, *movieRuntimeLabel;
    UIImage *movieBackgroundImage;
    MovieView *movieView;
    CGFloat yOffset;
    //UITableViewCell *cell;
}

@synthesize rateView, oneMovieActivityView, movieID, movieName, movieRelease, movieGenre, movieRuntime, movieBackground, moviePlot, moviePoster, json, creditsJson, movieTableView, castArray, tableView, movieTVC, movieDirectors, movieWriters;

BOOL keyboardVisible = NO;
UITapGestureRecognizer *tap;

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"LADDAT: RateViewController");
    [self.navigationController.navigationBar setTintColor:[UIColor colorWithRed:0.855 green:0.243 blue:0.251 alpha:1]];
    self.navigationController.navigationBar.translucent = YES;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
    [DejalActivityView activityViewForView:self.view].showNetworkActivityIndicator = YES;
    self.view.userInteractionEnabled = NO;
    
    //Skapar scollView
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.delegate = self;
    self.scrollView.alwaysBounceVertical = YES;
    
    //Tar bort tangentbordet om man klickar inom scrollView
    tap = [[UITapGestureRecognizer alloc]
           initWithTarget:self
           action:@selector(dismissKeyboard)];
    
    //Om det inte finns något årtal
    if([movieRelease isEqualToString:@""])
        movieRelease = @"xxxx-xx-xx";
    
    //Filminfo
    NSString *movieTitle = movieName;
    NSString *movieReleaseString = [NSString stringWithFormat:@"(%@)", [movieRelease substringToIndex:4]];
    
    //Om titeln är för lång så kortas den ned
    if (movieTitle.length > 110)
        movieTitle = [[movieTitle substringToIndex:110] stringByAppendingString:@"..."];
    
    /*
     Denna sektion skapar filmtitelns label. Vi lägger dessutom in filmens releasedatum i samma label eftersom den alltid ska ligga precis efter filmtiteln.
     Metoden "stringByPaddingToLength" utökar sedan strängen så att den alltid är 100 tecken, annars hamnar texten på olika höjd beroende på längden på titeln.
     Vi flyttar sedan movieTitleLabel.frame till rätt höjd beroende på hur hög labeln är (alltså hur många rader). Detta gör vi eftersom vi vill få plats med runtime och genre under.
     De fyra sista raderna tar movieTitleLabel och gör om fonten på de sista bokstäverna eftersom det som sagt är årtalet och vi vill att årtalets typsnitt ska vara mindre och ha annan färg.
     */
    movieTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 140, 300, 60)];
    movieTitleLabel.text = [NSString stringWithFormat:@"%@ %@ ", movieTitle, movieReleaseString];
    movieTitleLabel.textColor=[UIColor whiteColor];
    movieTitleLabel.numberOfLines = 4;
    movieTitleLabel.textAlignment = NSTextAlignmentLeft;
    movieTitleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [movieTitleLabel setFont:[UIFont fontWithName: @"HelveticaNeue-Light" size: 22.0]];
    [movieTitleLabel sizeToFit];
    movieTitleLabel.frame = CGRectMake(10, backdropImageHeight-movieTitleLabel.frame.size.height-50, 300, movieTitleLabel.frame.size.height);
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithAttributedString: movieTitleLabel.attributedText];
    [text addAttribute: NSForegroundColorAttributeName value: [UIColor lightGrayColor] range: NSMakeRange([movieTitle length]+1, 6)];
    [text addAttribute: NSFontAttributeName value: [UIFont fontWithName: @"HelveticaNeue-Light" size: 16.0] range: NSMakeRange([movieTitle length]+1, 6)];
    [movieTitleLabel setAttributedText: text];
    
    //Filmens bakgrundsbild
    self.backdropImageView = [[UIImageView alloc] init];
    self.backdropImageView.backgroundColor = [UIColor darkGrayColor];
    self.backdropImageView.frame = CGRectMake(0, 0, backdropImageWidth, backdropImageHeight);
    self.backdropImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.backdropImageView setClipsToBounds:YES];
    
    self.backdropWithBlurImageView = [[UIImageView alloc] init];
    self.backdropWithBlurImageView.frame = CGRectMake(0, 0, backdropImageWidth, backdropImageHeight);
    self.backdropWithBlurImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.backdropWithBlurImageView setClipsToBounds:YES];
    
    /*
     UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
     activityIndicator.frame = CGRectMake(0, 0, backdropImageWidth, backdropImageHeight-50);
     [activityIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];
     [activityIndicator startAnimating];
     [self.backdropImageView addSubview:activityIndicator];
     */
    
    //SKAPAR NY TRÅD FÖR INLADDNING AV DATA
    dispatch_queue_t queue = dispatch_queue_create("myqueue", NULL);
    dispatch_async(queue, ^{
        
        NSLog(@"LADDAR: Backdrop från: %@", movieBackground);
        NSString *backDropURL = [NSString stringWithFormat:@"http://image.tmdb.org/t/p/w780/%@", movieBackground];
        NSURL *imageURL = [NSURL URLWithString:backDropURL];
        NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
        UIImage *img = [UIImage imageWithData:imageData];
        NSLog(@"HÄMTAT: Backdrop från: %@", movieBackground);
        
        NSLog(@"LADDAR: Filmdata från TMDb");
        [self retrieveData];
        NSLog(@"HÄMTAT: Filmdata från TMDb");
        
        //Parsar filminfo till movieView
        //Plot
        moviePlot = [json valueForKey:@"overview"];
        //Poster
        NSString *posterPath = [json valueForKey:@"poster_path"];
        NSString *posterString = [NSString stringWithFormat:@"https://image.tmdb.org/t/p/w185%@", posterPath];
        NSURL *posterURL = [NSURL URLWithString:posterString];
        moviePoster = [NSData dataWithContentsOfURL:posterURL];
        
        //Lägger cast i en array
        castArray = [creditsJson objectForKey:@"cast"];
        NSUInteger castInt;
        if([castArray count] > 7)
            castInt = 7;
        else
            castInt = [castArray count];
        
        //Hämtar crew
        NSMutableArray *movieCrew = [creditsJson objectForKey:@"crew"];
        NSString *jobTitle;
        
        //Directors
        movieDirectors  = [[NSMutableArray alloc] init];
        for(int i=0; i<[movieCrew count]; i++){
            jobTitle = [movieCrew[i] objectForKey:@"job"];
            if([jobTitle isEqualToString:@"Director"])
                [movieDirectors addObject:[movieCrew[i] objectForKey:@"name"]];
        }
        //Writers
        movieWriters  = [[NSMutableArray alloc] init];
        for(int i=0; i<[movieCrew count]; i++){
            jobTitle = [movieCrew[i] objectForKey:@"job"];
            if([jobTitle isEqualToString:@"Screenplay"] || [jobTitle isEqualToString:@"Author"] || [jobTitle isEqualToString:@"Writer"])
                [movieWriters addObject:[movieCrew[i] objectForKey:@"name"]];
        }
        
        //Skapar movieTableView
        movieTVC = [[MovieTableViewController alloc]initWithData:castArray];
        movieTableView = movieTVC.view;
        
        //Lägger genrar i en array
        NSArray *genreArray = [json objectForKey:@"genres"];
        
        //Castar runtime till runTimeString och sätter sedan movieRuntimeString
        NSString *runTimeString = [[json objectForKey:@"runtime"] stringValue];
        NSString *movieRuntimeString = @"";
        if(![runTimeString isEqual: @"0"])
            movieRuntimeString = [runTimeString stringByAppendingString:@" min"];
        
        // Perform on main thread/queue
        dispatch_async(dispatch_get_main_queue(), ^{
            
            //Allokerar och initierar vyerna för segmented control
            
            movieView = [[MovieView alloc] initWithMovieInfo:CGRectMake(0, backdropImageHeight, 320, 280+castInt*75):moviePoster:moviePlot:movieDirectors:movieWriters:movieTableView:self];
            //Tabellen med skådisar läggs till i moviewView
            [movieView addSubview:movieTVC.view];
            
            rateView = [[RateView alloc] initWithMovieID:CGRectMake(0, backdropImageHeight, 320, 300):movieID];
            rateView.commentField.delegate = self;
            [rateView.commentField setReturnKeyType:UIReturnKeyDone];
            oneMovieActivityView = [[ActivityViewController alloc]initWithOneMovie:movieID:movieName:moviePoster:backdropImageHeight];
            oneMovieActivityView.view.frame = CGRectMake(0, backdropImageHeight+45, 320, 600);
            
            //Kollar om tengentbordet visas
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(keyboardWillShow:)
                                                         name:UIKeyboardWillShowNotification
                                                       object:nil];
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(keyboardWillHide:)
                                                         name:UIKeyboardWillHideNotification
                                                       object:nil];
            
            //Gömmer tangentbordet om man klickar någon annanstans i den här vyn
            tap = [[UITapGestureRecognizer alloc]initWithTarget:self
                                                         action:@selector(dismissKeyboard)];
            [self.view addGestureRecognizer:tap];
            
            //Formaterar en sträng med genrar
            NSString *movieGenreString = @"";
            for (int i = 0; i < [genreArray count]; i++) {
                NSString *tmp = [[genreArray objectAtIndex:i] objectForKey:@"name"];
                if([tmp isEqualToString:@"Science Fiction"])
                    tmp = @"Sci-Fi";
                movieGenreString = [movieGenreString stringByAppendingString:tmp];
                if (i < [genreArray count]-1)
                    movieGenreString = [movieGenreString stringByAppendingString: @" | "];
            }
            
            //Genre label
            NSLog(@"LADDAR: Genre");
            movieGenresLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, movieTitleLabel.frame.origin.y+movieTitleLabel.frame.size.height+4, 140, 20)];
            movieGenresLabel.text = movieGenreString;
            movieGenresLabel.textColor=[UIColor lightGrayColor];
            movieGenresLabel.textAlignment = NSTextAlignmentLeft;
            [movieGenresLabel setFont:[UIFont fontWithName: @"HelveticaNeue" size: 13.0]];
            [movieGenresLabel sizeToFit];
            NSLog(@"HÄMTAT: Genre");
            
            //Runtime label
            NSLog(@"LADDAR: Runtime");
            movieRuntimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, movieGenresLabel.frame.origin.y+movieGenresLabel.frame.size.height+2, 140, 20)];
            movieRuntimeLabel.text = movieRuntimeString;
            movieRuntimeLabel.textColor=[UIColor lightGrayColor];
            movieRuntimeLabel.textAlignment = NSTextAlignmentLeft;
            [movieRuntimeLabel setFont:[UIFont fontWithName: @"HelveticaNeue" size: 13.0]];
            [movieRuntimeLabel sizeToFit];
            NSLog(@"HÄMTAT: Runtime");
            
            self.scrollView.contentSize = CGSizeMake(320, movieView.frame.size.height+backdropImageHeight);
            [self.scrollView addSubview:movieView];
            [self.scrollView addSubview:rateView];
            [self.scrollView addSubview:movieGenresLabel];
            [self.scrollView addSubview:movieRuntimeLabel];
            
            if([rateView superview]!=nil)
                NSLog(@"visible");
            else
                NSLog(@"not visible");
            
            //Gömmer de vyer som inte ska synnas i Segmented Control vid load
            rateView.hidden = TRUE;
            oneMovieActivityView.view.hidden = TRUE;
            
            if([movieBackground isEqual: [NSNull null]]){
                [self.backdropImageView setImage: [UIImage imageNamed:@"moviebackdropplaceholder"]];
                [self.backdropWithBlurImageView setImage: [[UIImage imageNamed:@"moviebackdropplaceholder"]applyDarkEffectWithIntensity:0 darkness:0.6]];
            }else{
                [self.backdropImageView setImage: img];
                [self.backdropWithBlurImageView setImage: [img applyDarkEffectWithIntensity:0 darkness:0.6]];
            }
            
            //Skapar segmented control-menyn
            UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"Movie details", @"Rate movie", @"Friend activity", nil]];
            segmentedControl.frame = CGRectMake(10, backdropImageHeight+10, 300, 29);
            segmentedControl.selectedSegmentIndex = 0;
            segmentedControl.tintColor = [UIColor colorWithRed:0.855 green:0.243 blue:0.251 alpha:1];
            [segmentedControl addTarget:self action:@selector(valueChanged:) forControlEvents: UIControlEventValueChanged];
            
            //Lägger till alla subviews i den här vyn
            [self.view addSubview:self.backdropImageView];
            [self.view addSubview:self.backdropWithBlurImageView];
            [self.scrollView addSubview:self.oneMovieActivityView.view];
            [self.scrollView addSubview:movieTitleLabel];
            [self.scrollView addSubview:segmentedControl];
            [self.view addSubview:self.scrollView];
            
            [DejalActivityView removeView];
            self.view.userInteractionEnabled = YES;
            
            //Färg på navigationBaren
            self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
            
        });
    });
    
    //Ska göra det enklare att använda slidern, vet ej om det funkar
    self.scrollView.canCancelContentTouches = YES;
    self.scrollView.delaysContentTouches = YES;
    
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    
    //Tar bort "Back"-texten på filmsidorna
    self.navigationController.navigationBar.topItem.backBarButtonItem = [[UIBarButtonItem alloc]
                                                                         initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    //Sätter ramen för scrollView
    CGRect bounds = self.view.bounds;
    bounds.size.height -= 50;
    self.scrollView.frame = bounds;
    
    self.view.backgroundColor = [UIColor colorWithRed:0.96 green:0.96 blue:0.94 alpha:1];
    
    NSMutableDictionary* sendingObject;
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(receiveData:)
     name:[NSString stringWithFormat:@"%@%@", [PFUser currentUser].objectId, movieID]
     object:sendingObject];
    
}

- (void)receiveData:(NSNotification *)notification {
    
    [DejalBezelActivityView activityViewForView:self.view];
    
    if ([notification.name isEqualToString:[NSString stringWithFormat:@"%@%@", [PFUser currentUser].objectId, movieID]])
    {
        NSDictionary* userInfo = notification.userInfo;
        NSString *user = [userInfo objectForKey:@"user"];
        NSString *movie = [userInfo objectForKey:@"movie"];
        NSString *comment = [userInfo objectForKey:@"comment"];
        NSNumber *myRating = [userInfo objectForKey:@"rating"];
        NSLog (@"Successfully received test notification! %@", user);
        
        
        PFUser *currentUser = [PFUser currentUser];
        if (currentUser) {
            
            PFQuery *query = [PFQuery queryWithClassName:@"Rating"];
            [query whereKey:@"user" equalTo:currentUser.username];
            [query whereKey:@"movieId" equalTo:movie];
            [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
                if (object){
                    [object deleteInBackground];
                } else {
                    PFObject *rating = [PFObject objectWithClassName:@"Rating"];
                    
                    rating[@"user"] = currentUser.username;
                    if([comment isEqualToString:@"How was it? Leave a note..."]) //Skickar in en tom string om man inte skriver nåt.
                        rating[@"comment"] = @"";
                    else
                        rating[@"comment"] = comment;
                    rating[@"rating"] = myRating;
                    rating[@"movieId"] = [NSString stringWithFormat:@"%@", self.movieID];
                    [rating saveInBackground];
                }
                [DejalBezelActivityView removeViewAnimated:YES];
                [self.tabBarController setSelectedIndex:0];
                [self.navigationController popViewControllerAnimated:YES];
            }];
            
            NSLog(@"Rating sparas...");
            
        }else{
            NSLog(@"Inte inloggad!");
        }

        
    }
    
    
}


//SCROLLVIEW
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [rateView.commentField resignFirstResponder];
    CGRect f;
    yOffset = self.scrollView.contentOffset.y;
    CGFloat enlargmentFactor = ((ABS(yOffset)+backdropImageHeight)*backdropImageWidth)/backdropImageHeight;
    float blurAlpha = (yOffset/70.0)+1.1;
    
    //Om man scrollar UP eller NER så ändras bakgrundbildens storlek och position
    //Anpassning efter tangentbord (-60 i y-led).
    if(keyboardVisible){
        if (yOffset < 0)
            f = CGRectMake(-(enlargmentFactor-backdropImageWidth)/2, -60, enlargmentFactor, backdropImageHeight+ABS(yOffset));
        else
            f = CGRectMake(0, -yOffset-60, backdropImageWidth, backdropImageHeight);
    }
    else{
        if (yOffset < 0)
            f = CGRectMake(-(enlargmentFactor-backdropImageWidth)/2, 0, enlargmentFactor, backdropImageHeight+ABS(yOffset));
        else
            f = CGRectMake(0, -yOffset, backdropImageWidth, backdropImageHeight);
    }
    
    if (yOffset > 90){
        [self.navigationController setNavigationBarHidden:YES animated:YES];
    }else if (yOffset < 90){
        [self.navigationController setNavigationBarHidden:NO animated:YES];
    }
    
    
    self.backdropImageView.frame = f;
    self.backdropWithBlurImageView.frame = f;
    
    //Alpha på bakgrundsbilden och alla label när man scrollar
    self.backdropWithBlurImageView.alpha = blurAlpha;
    movieTitleLabel.alpha = blurAlpha;
    movieRuntimeLabel.alpha = blurAlpha;
    movieGenresLabel.alpha = blurAlpha;
    
    //Log för debug
    NSLog(@"YOFFSET: %f", yOffset);
    //NSLog(@"BLUR ALPHA: %f", blurAlpha);
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

//SEGMENTED CONTROL
- (void)valueChanged:(UISegmentedControl *)segment {
    if(segment.selectedSegmentIndex == 0) {
        [self dismissKeyboard];
        movieView.hidden = FALSE;
        rateView.hidden = TRUE;
        tableView.hidden = TRUE;
        oneMovieActivityView.view.hidden = TRUE;
        self.scrollView.contentSize = CGSizeMake(320, movieView.frame.size.height+backdropImageHeight);
    }else if(segment.selectedSegmentIndex == 1){
        movieView.hidden = TRUE;
        rateView.hidden = FALSE;
        tableView.hidden = TRUE;
        oneMovieActivityView.view.hidden = TRUE;
        self.scrollView.contentSize = CGSizeMake(320, rateView.frame.size.height+backdropImageHeight);
        [self.scrollView addGestureRecognizer:tap];
    }else if(segment.selectedSegmentIndex == 2){
        [self dismissKeyboard];
        movieView.hidden = TRUE;
        rateView.hidden = TRUE;
        oneMovieActivityView.view.hidden = FALSE;
        [[oneMovieActivityView activityTable].tableView reloadData];
        self.scrollView.contentSize = CGSizeMake(320, oneMovieActivityView.view.frame.size.height+backdropImageHeight);
    }
}

- (void) retrieveData
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@", getDataURL, movieID, api_key]];
    NSData *data = [NSData dataWithContentsOfURL:url];
    json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    //NSLog(@"%@", json);
    
    NSURL *creditsURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@%@", getDataURL, movieID, getCreditsURL, api_key]];
    NSData *creditsData = [NSData dataWithContentsOfURL:creditsURL];
    creditsJson = [NSJSONSerialization JSONObjectWithData:creditsData options:kNilOptions error:nil];
    //NSLog(@"%@", creditsJson);
}


//Placeholder till commentFiled i rateView.
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([rateView.commentField.text isEqualToString:rateView.placeholder]) {
        rateView.commentField.text = @"";
        rateView.commentField.textColor = [UIColor blackColor];
    }
    [rateView.commentField becomeFirstResponder];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([rateView.commentField.text isEqualToString:@""]) {
        rateView.commentField.text = rateView.placeholder;
        rateView.commentField.textColor = [UIColor lightGrayColor];
    }
    [rateView.commentField resignFirstResponder];
}

//Håller koll på antal tecken i commentField (i rateView)
- (void)textViewDidChange:(UITextView *)textView{
    
    NSUInteger chars = [[textView text] length];
    chars = 140 - chars;
    rateView.characterLabel.text = [NSString stringWithFormat: @"%d", (int)chars];
    rateView.characterLabel.textColor = [UIColor lightGrayColor];
    
    if (chars > 140){
        rateView.characterLabel.textColor = [UIColor redColor];
    }
}

//Flyttar views när tangentbord visas
- (void)keyboardWillShow:(NSNotification *)note
{
    keyboardVisible = YES;

    [UIView beginAnimations:nil context:nil];
    
    CGRect screenRect = [[UIScreen mainScreen] applicationFrame];
    if (screenRect.size.height == 548)
        [self.view setFrame:CGRectMake (0,-62+yOffset,self.view.frame.size.width,self.view.frame.size.height)];
    else
        [self.view setFrame:CGRectMake (0,-155+yOffset,self.view.frame.size.width,self.view.frame.size.height)];
    
    

    [UIView commitAnimations];
}

- (void)keyboardWillHide:(NSNotification *)note
{
    keyboardVisible = NO;
    
    
    [UIView beginAnimations:nil context:nil];
    
    [self.view setFrame:CGRectMake (0,0,self.view.frame.size.width,self.view.frame.size.height)];
    
    [UIView commitAnimations];
    
}

-(void)dismissKeyboard {
    [rateView.commentField resignFirstResponder];
}


- (NSMutableArray*)getCastArray{
    return castArray;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqual:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

-(void)enlargeScrollView:(CGFloat)addedHeight{
    self.scrollView.contentSize = CGSizeMake(self.scrollView.contentSize.width, movieView.frame.size.height+backdropImageHeight+addedHeight);
}

- (void)view:(UIView *)view savedRating:(UIView *)subview
{
        NSLog(@"his view is in the process of being removed");
}

@end
