//
//  RateView.m
//  CinemApp
//
//  Created by mikael on 18/02/14.
//  Copyright (c) 2014 Rosquist Östlund. All rights reserved.
//

#import "RateView.h"

@implementation RateView{
UILabel *sliderLabel;
UISlider *slider;
    
}

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
        slider = [[UISlider alloc] initWithFrame:frame];
        slider.minimumValue = 0;
        slider.maximumValue = 10;
        slider.value = 5;
        //Vad som händer när man SLAJDAR
        [slider addTarget:self action:@selector(sliderAction:) forControlEvents:UIControlEventValueChanged];
        [slider setBackgroundColor:[UIColor clearColor]];
        [slider setTintColor:[UIColor colorWithRed:1.000 green:0.314 blue:0.329 alpha:1]];
        [self addSubview:slider];
        
        //sliderLabelBG
        UIImage *sliderLabelBG = [UIImage imageNamed:@"rate-score"];
        self.sliderLabelBGView = [[UIImageView alloc] initWithImage:sliderLabelBG];
        self.sliderLabelBGView.frame = CGRectMake(275, 72, 30, 30);
        [self addSubview:self.sliderLabelBGView];
        
        //sliderLabel
        sliderLabel = [[UILabel alloc]initWithFrame:CGRectMake(280, 65, 20, 44)];
        sliderLabel.text = @"5";
        sliderLabel.textColor = [UIColor whiteColor];
        sliderLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:sliderLabel];
        
        //commentLabel
        UILabel *commentLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 110, 100, 44)];
        commentLabel.text = @"Comment";
        [self addSubview:commentLabel];
        
        //commentField
        UITextField * commentField = [[UITextField alloc]initWithFrame:CGRectMake(20, 120, 280, 120)];
        commentField.placeholder = @"How was it? Leave a note...";
        commentField.borderStyle = UITextBorderStyleRoundedRect;
        commentField.textAlignment = 0;
        [self addSubview:commentField];
       
    }
    return self;
}

- (void)sliderAction:(id)sender {
    NSInteger val = (slider.value);
    sliderLabel.text = [NSString stringWithFormat:@"%d",val];
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
