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
        
        //slider
        CGRect frame = CGRectMake(20, 80, 240.0, 15);
        UISlider *slider = [[UISlider alloc] initWithFrame:frame];
       // Vad som händer när man SLAJDAR
       // [slider addTarget:self action:@selector(sliderAction:) forControlEvents:UIControlEventValueChanged];
        [slider setBackgroundColor:[UIColor clearColor]];
        [slider setTintColor:[UIColor colorWithRed:1.000 green:0.314 blue:0.329 alpha:1]];
        [self addSubview:slider];
        
        //sliderLabelBG
        UIImage *sliderLabelBG = [UIImage imageNamed:@"rate-score"];
        self.sliderLabelBGView = [[UIImageView alloc] initWithImage:sliderLabelBG];
        self.sliderLabelBGView.frame = CGRectMake(275, 72, 30, 30);
        [self addSubview:self.sliderLabelBGView];
        
        //sliderLabel
        UILabel *sliderLabel = [[UILabel alloc]initWithFrame:CGRectMake(285, 65, 15, 44)];
        sliderLabel.text = @"0";
        sliderLabel.textColor = [UIColor whiteColor];
        [self addSubview:sliderLabel];
        
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
