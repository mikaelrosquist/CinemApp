//in subclassed UIView
#import "MovieView.h"
#import "ImageEffects.h"

#define getDataURL @"api.themoviedb.org/3/movie/"
#define api_key @"2da45d86a9897bdf7e7eab86aa0485e3"

@implementation MovieView

@synthesize plotText = _plotText;
@synthesize plotField;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        //plotLabel
        UILabel *plotLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 30, 100, 44)];
        plotLabel.text = @"Plot";
        [self addSubview:plotLabel];
        
        //plotField
        plotField = [[UITextField alloc]initWithFrame:CGRectMake(10, 70, 300, 100)];
        plotField.enabled = NO;
        plotField.text = _plotText;
        NSLog(@"plotText satt!");
        plotField.borderStyle = UITextBorderStyleRoundedRect;
        plotField.textAlignment = 0;
        [self addSubview:plotField];
        
        //castLabel
        UILabel *castLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 170, 100, 44)];
        castLabel.text = @"Cast";
        [self addSubview:castLabel];
        
        //loopa igenom top-cast och skriv ut dem på nåt sätt.

    
    }
    return self;
}

@end
