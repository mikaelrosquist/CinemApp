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
        //rateLabel
        UILabel *rateLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 30, 100, 44)];
        rateLabel.text = @"Rating";
        [self addSubview:rateLabel];
        
        //Slider
        CGRect frame = CGRectMake(20, 80, 240.0, 15);
        UISlider *slider = [[UISlider alloc] initWithFrame:frame];
       // Vad som händer när man SLAJDAR
       // [slider addTarget:self action:@selector(sliderAction:) forControlEvents:UIControlEventValueChanged];
        [slider setBackgroundColor:[UIColor clearColor]];
        [slider setTintColor:[UIColor redColor]];
        [self addSubview:slider];
        
        //commentLabel
        UILabel *commentLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 110, 100, 44)];
        commentLabel.text = @"Comment";
        [self addSubview:commentLabel];
        
        //commentField
        UITextField * commentField = [[UITextField alloc]initWithFrame:CGRectMake(20, 120, 280, 200)];
        commentField.placeholder = @"How was it? Leave a note...";
        commentField.borderStyle = UITextBorderStyleRoundedRect;
      //  commentField.textAlignment =
        [self addSubview:commentField];
       
    }
    return self;
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
