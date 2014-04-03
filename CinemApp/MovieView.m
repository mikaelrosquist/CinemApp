//in subclassed UIView
#import "MovieView.h"
#import "ImageEffects.h"

#define getDataURL @"api.themoviedb.org/3/movie/"
#define api_key @"2da45d86a9897bdf7e7eab86aa0485e3"

@implementation MovieView

@synthesize plotText, plotView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        //plotLabel
        UILabel *plotLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 30, 100, 44)];
        plotLabel.text = @"Plot";
        [self addSubview:plotLabel];
        
        //plotView
        plotView = [[UITextView alloc]initWithFrame:CGRectMake(10, 70, 300, 100)];
        plotView.text = plotText;
        plotView.textAlignment = 0;
        [self addSubview:plotView];
        
        //castLabel
        UILabel *castLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 170, 100, 44)];
        castLabel.text = @"Cast";
        [self addSubview:castLabel];
        
        //loopa igenom top-cast och skriv ut dem på nåt sätt.

    
    }
    return self;
}

-(id)initWithMovieInfo:(NSString *)moviePlot :(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.plotText = moviePlot;
        //plotView
        plotView = [[UITextView alloc]initWithFrame:CGRectMake(80, 40, 230, 130)];
        plotView.text = moviePlot;
        [plotView setFont:[UIFont systemFontOfSize:12]];
        plotView.textAlignment = 0;
        [self addSubview:plotView];
        
        //Poster
        
        
        //castLabel
        UILabel *castLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 170, 100, 44)];
        castLabel.text = @"Cast";
        [self addSubview:castLabel];
        
        
    }
    return self;
}


@end
