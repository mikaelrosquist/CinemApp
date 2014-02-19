//in subclassed UIView
#import "TestView.h"
#import "ImageEffects.h"


@implementation TestView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        // initilize all your UIView components
        UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(20,30, 200, 44)];
        label1.text = @"Här kommer alla filmer vara";
        [self addSubview:label1]; //add label1 to your custom view
        
        UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake(20,80, 200, 44)];
        label2.text = @"testing";
        [self addSubview:label2]; //add label2 to your custom view
        
    }
    return self;
}
@end
