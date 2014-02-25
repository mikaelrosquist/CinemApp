//
//  RateViewController.m
//  TabBar
//
//  Created by Teodor Östlund on 2014-02-17.
//  Copyright (c) 2014 Teodor Östlund. All rights reserved.
//

#import "RateViewController.h"

#define getDataURL @"api.themoviedb.org/3/movie/"
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

@synthesize movieView, rateView, activityView, movieID, movieName, movieRelease, movieGenre, movieRuntime, movieBackground, json;

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    //Gör denna controller till delegate för ActivityTableView
    self.activityView.delegate = self;
    self.activityView.dataSource = self;
    
    //Allokerar och initierar vyerna för segmented control
    movieView = [[MovieView alloc]initWithFrame:CGRectMake(0, backdropImageHeight+10, 320, 200)];
    rateView = [[RateView alloc]initWithFrame:CGRectMake(0, backdropImageHeight+10, 320, 400)];
    activityView = [[ActivityTableView alloc]initWithFrame:CGRectMake(0, backdropImageHeight+10, 320, 300)];
    
    //Filminfo
    NSString *movieTitle = movieName;
    NSString *movieReleaseString = [NSString stringWithFormat:@"(%@)", [movieRelease substringToIndex:4]];
    NSString *movieGenreString = movieGenre;
    NSString *movieRuntimeString = movieRuntime;
    
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
    
    //Lägger till alla subviews i den här vyn
    [self.view addSubview:self.backdropImageView];
    [self.view addSubview:self.backdropWithBlurImageView];
    [self.scrollView addSubview:movieTitleLabel];
    [self.scrollView addSubview:movieGenresLabel];
    [self.scrollView addSubview:movieRuntimeLabel];
    [self.scrollView addSubview:movieView];
    [self.scrollView addSubview:rateView];
    [self.scrollView addSubview:activityView];
    [self.scrollView addSubview:segmentedControl];
    [self.view addSubview:self.scrollView];
    
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

    self.navigationController.navigationBar.topItem.backBarButtonItem = [[UIBarButtonItem alloc]
                                                                         initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    //Sätter ramen för scrollView
    CGRect bounds = self.view.bounds;
    self.scrollView.frame = bounds;
    
    rateView.hidden = TRUE;
    activityView.hidden = TRUE;
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:0.96 green:0.96 blue:0.94 alpha:1];
    //Gömmer de vyer som inte ska synnas i Segmented Control vid load

}

//Returnerar höjden för en cell
-(CGFloat)tableView : (UITableView*)tableView heightForRowAtIndexPath: (NSIndexPath*) indexPath{
    
    return [indexPath row] * 20;
    
   /* if (indexPath.row == 0)
        return 10;
    else
        return 40; */
}

//Returnerar en cell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [activityView dequeueReusableCellWithIdentifier:@"cell"];
    if(!cell){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:@"cell"];
    }
    return cell;
}

//antal rader per sektion, vi använder bara en sektion men metoden måste finnas med.
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
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
        activityView.hidden = TRUE;
        self.scrollView.contentSize = CGSizeMake(320, movieView.frame.size.height+backdropImageHeight);
    }else if(segment.selectedSegmentIndex == 1){
        movieView.hidden = TRUE;
        rateView.hidden = FALSE;
        activityView.hidden = TRUE;
        self.scrollView.contentSize = CGSizeMake(320, rateView.frame.size.height+backdropImageHeight);
    }else if(segment.selectedSegmentIndex == 2){
        movieView.hidden = TRUE;
        rateView.hidden = TRUE;
        activityView.hidden = FALSE;
        self.scrollView.contentSize = CGSizeMake(320, activityView.frame.size.height+backdropImageHeight);
    }
}




@end
