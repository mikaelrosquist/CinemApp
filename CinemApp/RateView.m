//
//  RateView.m
//  CinemApp
//
//  Created by mikael on 18/02/14.
//  Copyright (c) 2014 Rosquist Östlund. All rights reserved.
//

#import "RateView.h"
#import "Parse/Parse.h"

@implementation RateView{
    UILabel *sliderLabel;
    UISlider *slider;
}

@synthesize commentField, movieID;

-(id)initWithMovieID:(CGRect)frame :(NSString *)incomingMovieID
{
    self = [super initWithFrame:frame];
    if (self) {
        self.movieID = incomingMovieID; //Varningen klagar på att det är två variabler som heter movieID
        
        [self checkIfRated:self.movieID];
        
        //rateLabel
        UILabel *rateLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 30, 100, 44)];
        rateLabel.text = @"Your rating";
        [self addSubview:rateLabel];
        
        //slider
        CGRect frame = CGRectMake(10, 80, 260, 15);
        slider = [[UISlider alloc] initWithFrame:frame];
        slider.minimumValue = 0;
        slider.maximumValue = 10;
        slider.value = 5;
        
        //Vad som händer när man SLAJDAR
        [slider addTarget:self action:@selector(sliderAction:) forControlEvents:UIControlEventValueChanged];
        [slider setBackgroundColor:[UIColor clearColor]];
        [slider setTintColor:[UIColor colorWithRed:0.855 green:0.243 blue:0.251 alpha:1]];
        [self addSubview:slider];
        
        //sliderLabelBG
        UIImage *sliderLabelBG = [UIImage imageNamed:@"rate-score"];
        self.sliderLabelBGView = [[UIImageView alloc] initWithImage:sliderLabelBG];
        self.sliderLabelBGView.frame = CGRectMake(280, 72, 30, 30);
        [self addSubview:self.sliderLabelBGView];
        
        //sliderLabel
        sliderLabel = [[UILabel alloc]initWithFrame:CGRectMake(285, 65, 20, 44)];
        sliderLabel.textColor = [UIColor whiteColor];
        sliderLabel.textAlignment = NSTextAlignmentCenter;
        sliderLabel.text = @"5";
        [self addSubview:sliderLabel];
        
        //commentLabel
        UILabel *commentLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 100, 100, 44)];
        commentLabel.text = @"Comment";
        [self addSubview:commentLabel];
        
        //commentField
        commentField = [[UITextView alloc]initWithFrame:CGRectMake(10, 145, 300, 120)];
        commentField.text = @"How was it? Leave a note...";
        commentField.textAlignment = 0;
        [self addSubview:commentField];

        //rateButton
        UIButton *rateButton = [[UIButton alloc]initWithFrame:CGRectMake(10, 280, 300, 40)];
        [rateButton setTitle:@"Rate" forState:UIControlStateNormal];
        rateButton.layer.cornerRadius = 5.0f;
        rateButton.tintColor = [UIColor whiteColor];
        //normal state
        [rateButton setTitleColor:rateButton.tintColor forState:UIControlStateNormal];
        rateButton.backgroundColor = [UIColor colorWithRed:0.855 green:0.243 blue:0.251 alpha:1];
        //selected state
        //Fixa så att knappen blir mörkare när den markeras
        rateButton.showsTouchWhenHighlighted = YES;
        [rateButton addTarget:self action:@selector(saveRating:) forControlEvents:UIControlEventTouchUpInside];

        
        [self addSubview:rateButton];

        //Gömmer tangentbordet om man klickar någon annanstans i den här vyn
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                       initWithTarget:self
                                       action:@selector(dismissKeyboard)];
        [self addGestureRecognizer:tap];
        
        [self setBackgroundColor:[UIColor clearColor]];
        
        
        PFUser *currentUser = [PFUser currentUser];
        if (currentUser) {
            NSLog(@"Inloggad!");
            
            NSString *test = [NSString stringWithFormat:@"%@",self.movieID];
            
            PFQuery *query = [PFQuery queryWithClassName:@"Rating"];
            [query whereKey:@"user" equalTo:currentUser.username];
            [query whereKey:@"movieId" equalTo:test];
            [query countObjectsInBackgroundWithBlock:^(int count, NSError *error) {
                if (!error) {
                    // The count request succeeded. Log the count
                    NSLog(@"Den här filmen har betygsatts %d gånger av den här personen", count);
                } else {
                    // The request failed
                }
            }];
        }
    }
    return self;
}

-(void)saveRating:(id)sender {
    PFUser *currentUser = [PFUser currentUser];
    if (currentUser) {
        
        NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
        [f setNumberStyle:NSNumberFormatterDecimalStyle];
        NSNumber *myNumber = [f numberFromString:sliderLabel.text];
        
        PFObject *rating = [PFObject objectWithClassName:@"Rating"];
        rating[@"user"] = @"admin";
        rating[@"comment"] = commentField.text;
        rating[@"rating"] = myNumber;
        rating[@"movieId"] = [NSString stringWithFormat:@"%@", self.movieID];
        [rating saveInBackground];
        NSLog(@"Rating sparas...");

    }else{
        NSLog(@"Inte inloggad!");
    }
    
}

- (void)sliderAction:(id)sender {
    NSInteger val = lround(slider.value);
    sliderLabel.text = [NSString stringWithFormat:@"%d",val];
}

-(void)dismissKeyboard {
    [commentField resignFirstResponder];
}

-(void)checkIfRated:(NSString *)movieID {
    PFUser *currentUser = [PFUser currentUser];
    
    if (currentUser) {
        
        NSString *test = [NSString stringWithFormat:@"%@",self.movieID];
        PFQuery *query = [PFQuery queryWithClassName:@"Rating"];
        [query whereKey:@"user" equalTo:currentUser.username];
        [query whereKey:@"movieId" equalTo:test];
        [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
            if (object){
                    slider.value = [[object objectForKey:@"rating"] intValue];
                    NSInteger val = lround(slider.value);
                    sliderLabel.text = [NSString stringWithFormat:@"%d",val];
            } else {
                //Inget
            }
        }];
    }
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
