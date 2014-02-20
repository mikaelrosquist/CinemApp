//in subclassed UIView
#import "MovieView.h"
#import "ImageEffects.h"


@implementation MovieView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        // initilize all your UIView components
        UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(20,30, 200, 44)];
        label1.text = @"Här kommer alla filmer vara";
        [self addSubview:label1]; //add label1 to your custom view
        [self setBackgroundColor:[UIColor whiteColor]];
    
    }
    return self;
}
@end
