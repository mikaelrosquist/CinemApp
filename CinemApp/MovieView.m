//in subclassed UIView
#import "MovieView.h"
#import "ImageEffects.h"

#define getDataURL @"api.themoviedb.org/3/movie/"
#define api_key @"2da45d86a9897bdf7e7eab86aa0485e3"

@implementation MovieView

@synthesize plotText, plotView, posterView, castLabel;

BOOL plotEnlarged = NO;

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
        castLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 170, 100, 44)];
        castLabel.text = @"Cast";
        [self addSubview:castLabel];
        
        //loopa igenom top-cast och skriv ut dem på nåt sätt.
        
        
    }
    return self;
}

-(id)initWithMovieInfo:(CGRect)frame :(NSData*)posterImage :(NSString *)moviePlot :(NSArray *)castArray
{
    self = [super initWithFrame:frame];
    if (self) {
        self.plotText = moviePlot;
        //plotView
        plotView = [[UITextView alloc]initWithFrame:CGRectMake(10, 40, 300, 150)];
        plotView.text = moviePlot;
        [plotView setFont:[UIFont systemFontOfSize:14]];
        plotView.textAlignment = 0;
        [plotView setUserInteractionEnabled:NO];
        plotView.backgroundColor = [UIColor clearColor];
        [plotView setContentInset:UIEdgeInsetsMake(-10, -5, 10, 5)];
        UIBezierPath * imgRect = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, 97, 133)];
        self.plotView.textContainer.exclusionPaths = @[imgRect];
        [self addSubview:plotView];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                              action:@selector(tappedPlotView)];
        [plotView addGestureRecognizer:tap];
        plotView.editable = NO;
        plotView.scrollEnabled = NO;
        plotView.userInteractionEnabled = YES;
        
        //Poster
        posterView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 40, 90, 130)];
        posterView.image = [UIImage imageWithData:posterImage];
        [self addSubview:posterView];
        
        //castLabel
        castLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, plotView.frame.size.height+20, 100, 44)];
        castLabel.text = @"Cast";
        [self addSubview:castLabel];
        
        //cast
        
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
    NSLog(@"%f", plotView.contentSize.height);
    NSLog(@"%f", posterView.frame.size.height);
    
    if (plotEnlarged){
        [UIView beginAnimations:nil context:nil];
        [textView setFrame:CGRectMake(10, 40, 300, 150)];
        [UIView commitAnimations];
        plotEnlarged = NO;
    }
    else if(plotView.contentSize.height > posterView.frame.size.height){
        plotEnlarged = YES;
        CGFloat fixedWidth = textView.frame.size.width;
        CGSize newSize = [textView sizeThatFits:CGSizeMake(fixedWidth, MAXFLOAT)];
        CGRect newFrame = textView.frame;
        newFrame.size = CGSizeMake(fmaxf(newSize.width, fixedWidth), newSize.height);
        
        [UIView beginAnimations:nil context:nil];
        textView.frame = newFrame;
        [UIView commitAnimations];
    }
    
    //placerar castLabel vertikalt, beroende på plotView
    [self.castLabel setFrame:CGRectMake(10, textView.frame.size.height+20, 100, 44)];
    
}
@end
