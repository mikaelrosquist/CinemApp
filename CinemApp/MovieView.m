//in subclassed UIView
#import "MovieView.h"
#import "ImageEffects.h"


@implementation MovieView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        //plotLabel
        UILabel *plotLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 30, 100, 44)];
        plotLabel.text = @"Plot";
        [self addSubview:plotLabel];
        
        //plotField
        UITextField *plotField = [[UITextField alloc]initWithFrame:CGRectMake(10, 70, 300, 100)];
        plotField.text = @"Plot text";
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
