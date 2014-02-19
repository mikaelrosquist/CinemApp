//
//  RateView.m
//  CinemApp
//
//  Created by mikael on 18/02/14.
//  Copyright (c) 2014 Rosquist Östlund. All rights reserved.
//

#import "RateView.h"

@implementation RateView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        UIButton *testButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [testButton addTarget:self
                   action:@selector(callSuperMethod)
         forControlEvents:UIControlEventTouchDown];
        [testButton setTitle:@"Button" forState:UIControlStateNormal];
        testButton.frame = CGRectMake(80.0, 210.0, 160.0, 40.0);
        [self addSubview:testButton];
        
        
        //UISlider *slider = [[UISlider alloc] initWithFrame:frame];
        //[slider addTarget:self action:@selector(sliderAction:) forControlEvents:UIControlEventValueChanged];
        //[slider setBackgroundColor:[UIColor clearColor]];
        
        // Initialization code
    }
    return self;
}

- (void) callSuperMethod{
    //[ buttonPressed];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
