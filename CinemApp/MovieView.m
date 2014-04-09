//in subclassed UIView
#import "MovieView.h"
#import "ImageEffects.h"

#define getDataURL @"api.themoviedb.org/3/movie/"
#define api_key @"2da45d86a9897bdf7e7eab86aa0485e3"

@implementation MovieView

@synthesize plotText, plotView, posterView, castLabel, personView;

BOOL plotEnlarged = NO;
MovieTableView *castTable;

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
        plotView.selectable = NO; //så man inte kan markera/kopiera text
        plotView.scrollEnabled = NO;
        plotView.userInteractionEnabled = YES;
        
        //Poster
        posterView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 40, 90, 130)];
        posterView.image = [UIImage imageWithData:posterImage];
        [self addSubview:posterView];
        
        //castLabel
        castLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, plotView.frame.size.height+20, 100, 44)];
        castLabel.text = @"Top Cast";
        [self addSubview:castLabel];
        
        //castTable
        castTable = [[MovieTableView alloc]initWithData:CGRectMake(0, plotView.frame.size.height+60, 320, 400):castArray];
        [self addSubview:castTable];
        
        //cast
        //NSLog(@"CastArray: %@", castArray);
        
      /*  double y = 0.2;
        if (![castArray count] < 1) {
            for (int i=0; i < 5; i++) {
                NSString *nameStr = [[castArray objectAtIndex:i] objectForKey:@"name"];
                NSString *charStr = [[castArray objectAtIndex:i] objectForKey:@"character"];
                //profile pics
                NSString *imagePath = [[castArray objectAtIndex:i] objectForKey:@"profile_path"];
                NSString *imageString = [NSString stringWithFormat:@"http://image.tmdb.org/t/p/w90%@", imagePath];
                NSURL *imageURL = [NSURL URLWithString:imageString];
                NSData *personImage = [NSData dataWithContentsOfURL:imageURL];
                personView = [[UIImageView alloc]initWithFrame:CGRectMake(10, plotView.frame.size.height+65 +i*90, 59, 87)];
                personView.image = [UIImage imageWithData:personImage];
                [self addSubview:personView];
                
                UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(82, plotView.frame.size.height+75 +i*90, 200, 44)];
                nameLabel.text = nameStr;
                UILabel *charLabel = [[UILabel alloc]initWithFrame:CGRectMake(82, plotView.frame.size.height+75 +y*90, 200, 44)];
                charLabel.font = [charLabel.font fontWithSize:12];
                charLabel.textColor = [UIColor grayColor];
                charLabel.text = charStr;
                y++;
                [self addSubview:nameLabel];
                [self addSubview:charLabel];
            }
        } */
        
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
    NSLog(@"Plot content: %f", plotView.contentSize.height);
    NSLog(@"Plot frame: %f", plotView.frame.size.height);
    NSLog(@"Poster: %f", posterView.frame.size.height);
    
    CGFloat fixedWidth = textView.frame.size.width;
    CGSize newSize = [textView sizeThatFits:CGSizeMake(fixedWidth, MAXFLOAT)];
    CGRect newFrame = textView.frame;
    newFrame.size = CGSizeMake(fmaxf(newSize.width, fixedWidth), newSize.height);
    
    if(newFrame.size.height < 150 || plotEnlarged){
        newFrame = CGRectMake(10, 40, 300, 150);
        plotEnlarged = NO;
    }
    else
        plotEnlarged = YES;
    
    [UIView beginAnimations:nil context:nil];
    textView.frame = newFrame;
    [self.castLabel setFrame:CGRectMake(10, textView.frame.size.height+20, 100, 44)];
    [castTable setFrame:CGRectMake(0, textView.frame.size.height+60, 320, 400)];
    [UIView commitAnimations];
}
@end
