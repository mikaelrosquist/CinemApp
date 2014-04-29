//
//  ActivityTableView.m
//  CinemApp
//
//  Created by mikael on 21/02/14.
//  Copyright (c) 2014 Rosquist Östlund. All rights reserved.
//






//ANVÄNDS INTE FÖR NÄRVARANDE!





#import "ActivityTableView.h"

@implementation ActivityTableView

@synthesize tableCell;

float height = 80;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        tableCell = [[ActivityTableViewCell alloc] init];
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
