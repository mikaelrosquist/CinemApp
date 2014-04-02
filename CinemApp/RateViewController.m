//
//  RateViewController.m
//  TabBar
//
//  Created by Teodor Östlund on 2014-02-17.
//  Copyright (c) 2014 Teodor Östlund. All rights reserved.
//

#import "RateViewController.h"

#define getDataURL @"api.themoviedb.org/3/movie/"
#define test @"http://api.themoviedb.org/3/movie/109445?api_key=2da45d86a9897bdf7e7eab86aa0485e3"
#define api_key @"2da45d86a9897bdf7e7eab86aa0485e3"

//Sätter backgrundsbildens höjd och bredd till statiska värden
static CGFloat backdropImageHeight  = 250.0;
static CGFloat backdropImageWidth  = 320.0;

@interface RateViewController ()

@end

@implementation RateViewController{
    UILabel *movieTitleLabel, *movieGenresLabel, *movieRuntimeLabel;
    //UITableViewCell *cell;
}

@synthesize movieView, rateView, movieID, movieName, movieRelease, movieGenre, movieRuntime, movieBackground, json, tableView;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Allokerar och initierar vyerna för segmented control

    movieView = [[MovieView alloc]initWithFrame:CGRectMake(0, backdropImageHeight+10, 320, 450)];
    rateView = [[RateView alloc]initWithFrame:CGRectMake(0, backdropImageHeight+10, 320, 400)];
    tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, backdropImageHeight+10, 320, 300)];
    
    //Om det inte finns något årtal
    if([movieRelease isEqualToString:@""])
        movieRelease = @"xxxx-xx-xx";
    
    //Filminfo
    NSString *movieTitle = movieName;
    NSString *movieReleaseString = [NSString stringWithFormat:@"(%@)", [movieRelease substringToIndex:4]];
    NSString *movieGenreString = @"Action";
    NSString *movieRuntimeString = [movieRuntime stringByAppendingString:@" min"];
    
    NSString *backDropURL = [NSString stringWithFormat:@"http://image.tmdb.org/t/p/w780/%@", movieBackground];
    
    NSURL *imageURL = [NSURL URLWithString:backDropURL];
    NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
    UIImage *movieBackgroundString = [UIImage imageWithData:imageData];
        
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
    movieTitleLabel.frame = CGRectMake(10, backdropImageHeight-movieTitleLabel.frame.size.height-70, 300, movieTitleLabel.frame.size.height);
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithAttributedString: movieTitleLabel.attributedText];
    [text addAttribute: NSForegroundColorAttributeName value: [UIColor lightGrayColor] range: NSMakeRange([movieTitle length]+1, 6)];
    [text addAttribute: NSFontAttributeName value: [UIFont fontWithName: @"HelveticaNeue-Light" size: 16.0] range: NSMakeRange([movieTitle length]+1, 6)];
    [movieTitleLabel setAttributedText: text];
    
    //Genre label
    movieGenresLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, movieTitleLabel.frame.origin.y+movieTitleLabel.frame.size.height+4, 140, 20)];
    movieGenresLabel.text = movieGenreString;
    movieGenresLabel.textColor=[UIColor lightGrayColor];
    movieGenresLabel.textAlignment = NSTextAlignmentLeft;
    [movieGenresLabel setFont:[UIFont fontWithName: @"HelveticaNeue" size: 13.0]];
    [movieGenresLabel sizeToFit];
    
    //Runtime label
    movieRuntimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, movieGenresLabel.frame.origin.y+movieGenresLabel.frame.size.height+2, 140, 20)];
    movieRuntimeLabel.text = movieRuntimeString;
    movieRuntimeLabel.textColor=[UIColor lightGrayColor];
    movieRuntimeLabel.textAlignment = NSTextAlignmentLeft;
    [movieRuntimeLabel setFont:[UIFont fontWithName: @"HelveticaNeue" size: 13.0]];
    [movieRuntimeLabel sizeToFit];
    
    //Filmens bakgrundsbild
    self.backdropImageView = [[UIImageView alloc] initWithImage:movieBackgroundString];
    self.backdropImageView.frame = CGRectMake(0, 0, backdropImageWidth, backdropImageHeight);
    self.backdropImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.backdropImageView setClipsToBounds:YES];
    
    //Filmens bakgrundbild med blur
    self.backdropWithBlurImageView = [[UIImageView alloc] initWithImage:movieBackgroundString];
    self.backdropWithBlurImageView.frame = CGRectMake(0, 0, backdropImageWidth, backdropImageHeight);
    self.backdropWithBlurImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.backdropWithBlurImageView.image = [movieBackgroundString applyDarkEffectWithIntensity:0 darkness:0.5];
    [self.backdropWithBlurImageView setClipsToBounds:YES];
    
    
    //Skapar segmented control-menyn
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"Information", @"Rate", @"Activity", nil]];
    segmentedControl.frame = CGRectMake(10, backdropImageHeight+10, 300, 29);
    segmentedControl.selectedSegmentIndex = 0;
    segmentedControl.tintColor = [UIColor colorWithRed:0.855 green:0.243 blue:0.251 alpha:1];
    [segmentedControl addTarget:self action:@selector(valueChanged:) forControlEvents: UIControlEventValueChanged];
    
    //Skapar scollView
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.delegate = self;
    self.scrollView.contentSize = CGSizeMake(320, movieView.frame.size.height+backdropImageHeight);
    self.scrollView.alwaysBounceVertical = YES;
    
    //skapar tableView
    self.tableView = [[UITableView alloc] init];
    self.tableView.delegate = self;
    self.tableView.contentSize = CGSizeMake(320, movieView.frame.size.height+backdropImageHeight);
    
    //Lägger till alla subviews i den här vyn
    [self.view addSubview:self.backdropImageView];
    [self.view addSubview:self.backdropWithBlurImageView];
    [self.scrollView addSubview:movieTitleLabel];
    [self.scrollView addSubview:movieGenresLabel];
    [self.scrollView addSubview:movieRuntimeLabel];
    [self.scrollView addSubview:movieView];
    [self.scrollView addSubview:rateView];
    [self.scrollView addSubview:segmentedControl];
    [self.view addSubview:self.scrollView];
    [self.view addSubview:self.tableView];
    
    //Ska göra det enklare att använda slidern, vet ej om det funkar
    self.scrollView.canCancelContentTouches = YES;
    self.scrollView.delaysContentTouches = YES;
    
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    
    //Färg på navigationBaren
    [self.navigationController.navigationBar setTintColor:[UIColor colorWithRed:0.855 green:0.243 blue:0.251 alpha:1]];
    self.navigationController.navigationBar.barTintColor = [UIColor clearColor];
    self.navigationController.navigationBar.translucent = YES;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;

    //Tar bort "Back"-texten på filmsidorna
    self.navigationController.navigationBar.topItem.backBarButtonItem = [[UIBarButtonItem alloc]
                                                                         initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    //Sätter ramen för scrollView
    CGRect bounds = self.view.bounds;
    bounds.size.height = self.view.frame.size.height+15;
    self.scrollView.frame = bounds;
    
    
    //Gömmer de vyer som inte ska synnas i Segmented Control vid load
    rateView.hidden = TRUE;
    tableView.hidden = TRUE;
    
    self.view.backgroundColor = [UIColor colorWithRed:0.96 green:0.96 blue:0.94 alpha:1];
    
    [self retrieveData];
    
}

//SCROLLVIEW
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGRect f;
    CGFloat yOffset = self.scrollView.contentOffset.y;
    CGFloat enlargmentFactor = ((ABS(yOffset)+backdropImageHeight)*backdropImageWidth)/backdropImageHeight;
    float blurAlpha = (yOffset/70.0)+1.1;
    
    //Om man scrollar UP eller NER så ändras bakgrundbildens storlek och position
    if (yOffset < 0)
        f = CGRectMake(-(enlargmentFactor-backdropImageWidth)/2, 0, enlargmentFactor, backdropImageHeight+ABS(yOffset));
    else
        f = CGRectMake(0, -yOffset, backdropImageWidth, backdropImageHeight);
    
    self.backdropImageView.frame = f;
    self.backdropWithBlurImageView.frame = f;
    
    //Alpha på bakgrundsbilden och alla label när man scrollar
    self.backdropWithBlurImageView.alpha = blurAlpha;
    movieTitleLabel.alpha = blurAlpha;
    movieRuntimeLabel.alpha = blurAlpha;
    movieGenresLabel.alpha = blurAlpha;
    
    //Log för debug
    NSLog(@"YOFFSET: %f", yOffset);
    NSLog(@"BLUR ALPHA: %f", blurAlpha);
}

//SEGMENTED CONTROL
- (void)valueChanged:(UISegmentedControl *)segment {
    if(segment.selectedSegmentIndex == 0) {
        movieView.hidden = FALSE;
        rateView.hidden = TRUE;
        tableView.hidden = TRUE;
        self.scrollView.contentSize = CGSizeMake(320, movieView.frame.size.height+backdropImageHeight);
    }else if(segment.selectedSegmentIndex == 1){
        movieView.hidden = TRUE;
        rateView.hidden = FALSE;
        tableView.hidden = TRUE;
        self.scrollView.contentSize = CGSizeMake(320, rateView.frame.size.height+backdropImageHeight);
    }else if(segment.selectedSegmentIndex == 2){
        movieView.hidden = TRUE;
        rateView.hidden = TRUE;
        tableView.hidden = FALSE;
        self.scrollView.contentSize = CGSizeMake(320, tableView.frame.size.height+backdropImageHeight);
    }
}

- (void) retrieveData
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@", test]];
    NSData *data = [NSData dataWithContentsOfURL:url];
    
    json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    
    NSLog(@"%@", json);
}

@end
