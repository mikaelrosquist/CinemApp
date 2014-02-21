//
//  ActivityView.m
//  CinemApp
//
//  Created by mikael on 20/02/14.
//  Copyright (c) 2014 Rosquist Östlund. All rights reserved.
//

#import "ActivityView.h"

@implementation ActivityView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(20,30, 200, 44)];
        label1.text = @"Här är aktiviteter";
        [self addSubview:label1]; //add label1 to your custom view
        
        [self setBackgroundColor:[UIColor whiteColor]];
        
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
