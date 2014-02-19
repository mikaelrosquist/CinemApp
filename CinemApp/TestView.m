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
        label1.text = @"i am label 1";
        [self addSubview:label1]; //add label1 to your custom view
        
        UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake(20,80, 200, 44)];
        label2.text = @"i am label 2";
        [self addSubview:label2]; //add label2 to your custom view
        
    }
    return self;
}
@end
