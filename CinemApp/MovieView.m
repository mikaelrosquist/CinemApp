#import "MovieView.h"
#import "MovieTableView.h"
#import "MovieTableViewController.h"
#import "RateViewController.h"
#import "ImageEffects.h"
#import <UIKit/UIKit.h>

#define getDataURL @"api.themoviedb.org/3/movie/"
#define api_key @"2da45d86a9897bdf7e7eab86aa0485e3"

@implementation MovieView

@synthesize plotText, plotView, posterView, castLabel, castTable, directorLabel, writerLabel, directorsArray, writersArray, plotEnlarged, rvc;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    
        plotEnlarged = NO;
        
        //plotLabel
        UILabel *plotLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 40, 100, 44)];
        plotLabel.text = @"Plot";
        [self addSubview:plotLabel];
        
        //plotView
        plotView = [[UITextView alloc]initWithFrame:CGRectMake(10, 80, 300, 100)];
        plotView.text = plotText;
        plotView.textAlignment = 0;
        [self addSubview:plotView];
        
        //castLabel
        castLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 180, 100, 44)];
        castLabel.text = @"Cast";
        [self addSubview:castLabel];
        
        //loopa igenom top-cast och skriv ut dem på nåt sätt.
        
    }
    return self;
}

-(id)initWithMovieInfo:(CGRect)frame :(NSData*)posterImage :(NSString *)moviePlot :(NSMutableArray *)directors :(NSMutableArray *)writers :(UITableView *)castTableView :(RateViewController *)rateViewController
{
    self = [super initWithFrame:frame];
    if (self) {
        rvc = rateViewController;
        
        self.plotText = moviePlot;
        //plotView
        plotView = [[UITextView alloc]initWithFrame:CGRectMake(10, 50, 310, 150)];
        plotView.text = moviePlot;
        [plotView setFont:[UIFont systemFontOfSize:14]];
        plotView.textAlignment = NSTextAlignmentJustified;
        [plotView setUserInteractionEnabled:NO];
        plotView.backgroundColor = [UIColor clearColor];
        [plotView setContentInset:UIEdgeInsetsMake(-11, -5, 11, 5)];
        UIBezierPath * imgRect = [UIBezierPath bezierPathWithRect:CGRectMake(0, 10, 97, 120)];
        self.plotView.textContainer.exclusionPaths = @[imgRect];
        [self addSubview:plotView];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                              action:@selector(tappedPlotView)];
        [self.plotView addGestureRecognizer:tap];
        plotView.editable = NO;
        plotView.selectable = NO; //så man inte kan markera/kopiera text
        plotView.scrollEnabled = NO;
        plotView.userInteractionEnabled = YES;
        
        //Poster
        posterView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 50, 90, 128)];
        posterView.image = [UIImage imageWithData:posterImage];
        [self addSubview:posterView];
        
        //Directors och writers
        directorsArray = directors;
        writersArray = writers;
        
        //NSLog(@"Directors: %@", directorsArray);
        //NSLog(@"Writers: %@", writersArray);
        
        NSString *directorString;
        directorLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, plotView.frame.size.height+35, 300, 30)];
        directorLabel.font = [UIFont fontWithName:@"Helvetica Neue" size:16];
        directorLabel.textColor = [UIColor lightGrayColor];
        if([directorsArray count] > 1)
            directorString = @"Directors: ";
        else
            directorString = @"Director: ";
        NSString *str;
        for (int i=0; i < [directorsArray count]; i++) {
            str = directorsArray[i];
            directorString = [directorString stringByAppendingString:str];
            if(i < [directorsArray count]-1)
                directorString = [directorString stringByAppendingString:@", "];
        }
        
        if([directorString isEqualToString:@"Director: "])
            directorString = [directorString stringByAppendingString:@"N/A"];
        
        directorLabel.text = directorString;
        [self addSubview:directorLabel];
        
        str = @"";
        NSString *writerString;
        writerLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, plotView.frame.size.height+60, 300, 30)];
        writerLabel.font = [UIFont fontWithName:@"Helvetica Neue" size:16];
        writerLabel.textColor = [UIColor lightGrayColor];
        
        if([writersArray count] > 1)
            writerString = @"Writers: ";
        else
            writerString = @"Writer: ";
        
        for (int i=0; i < [writersArray count]; i++) {
            str = writersArray[i];
            writerString = [writerString stringByAppendingString:str];
            if(i < [writersArray count]-1)
                writerString = [writerString stringByAppendingString:@", "];
        }
        
        if([writerString isEqualToString:@"Writer: "])
            writerString = [writerString stringByAppendingString:@"N/A"];
            
        writerLabel.text = writerString;
        [self addSubview:writerLabel];
        
        
        //castLabel
        castLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, plotView.frame.size.height+85, 100, 44)];
        castLabel.text = @"Top Cast";
        [self addSubview:castLabel];
        
        //castTable
        castTable = castTableView;
        [self addSubview:self.castTable];
    }
    return self;
}

//Gör bara ett anrop för att minska eller förstora plot-texten
- (void)tappedPlotView
{
    [self textViewDidChange:plotView];
}


//förstorar och förminskar plot-texten.
- (void)textViewDidChange:(UITextView *)textView
{
    
    //NSLog(@"movieView Height: %f", self.frame.size.height);
    //NSLog(@"Plot content: %f", plotView.contentSize.height);
    //NSLog(@"Plot frame: %f", plotView.frame.size.height);
    //NSLog(@"Poster: %f", posterView.frame.size.height);
    
    CGFloat fixedWidth = textView.frame.size.width;
    CGSize newSize = [textView sizeThatFits:CGSizeMake(fixedWidth, MAXFLOAT)];
    CGRect newFrame = textView.frame;
    newFrame.size = CGSizeMake(fmaxf(newSize.width, fixedWidth), newSize.height);
    
    if(newFrame.size.height < 150 || plotEnlarged){
        newFrame = CGRectMake(10, 50, 310, 150);
        plotEnlarged = NO;
    }
    else
        plotEnlarged = YES;
    
    [UIView beginAnimations:nil context:nil];
    textView.frame = newFrame;
    [self.castLabel setFrame:CGRectMake(10, textView.frame.size.height+85, 100, 44)];
    [self.directorLabel setFrame:CGRectMake(10, textView.frame.size.height+35, 300, 30)];
    [self.writerLabel setFrame:CGRectMake(10, textView.frame.size.height+60, 300, 30)];
    [castTable setFrame:CGRectMake(10, textView.frame.size.height+125, 300, 400)];
    [rvc enlargeScrollView:textView.frame.size.height-150];
    
    [UIView commitAnimations];
}

@end
