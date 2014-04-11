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
    UIButton *rateButton;
}

@synthesize commentField, movieID, characterLabel;

-(id)initWithMovieID:(CGRect)frame :(NSString *)incomingMovieID
{
    self = [super initWithFrame:frame];
    if (self) {
        self.movieID = incomingMovieID; //Varningen klagar på att det är två variabler som heter movieID
        
        [self checkIfRated:self.movieID];
        
        //slider
        CGRect frame = CGRectMake(10, 55, 260, 15);
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
        self.sliderLabelBGView.frame = CGRectMake(280, 47, 30, 30);
        [self addSubview:self.sliderLabelBGView];
        
        //sliderLabel
        sliderLabel = [[UILabel alloc]initWithFrame:CGRectMake(285, 40, 20, 44)];
        sliderLabel.textColor = [UIColor whiteColor];
        sliderLabel.font = [UIFont fontWithName:@"Helvetica Neue-Bold" size:16];
        sliderLabel.textAlignment = NSTextAlignmentCenter;
        sliderLabel.text = @"5";
        [self addSubview:sliderLabel];
        
        //visa i feed-switchen
        UILabel *feedLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 180, 100, 44)];
        feedLabel.text = @"Show in feed";
        [self addSubview:feedLabel];
        UISwitch *feedSwitch = [[UISwitch alloc]initWithFrame:CGRectMake(258, 190, 40, 20)];
        feedSwitch.onTintColor = [UIColor colorWithRed:0.855 green:0.243 blue:0.251 alpha:1];
        [feedSwitch setOn:YES];
        [self addSubview:feedSwitch];
        
        //commentLabel
        //UILabel *commentLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 150, 100, 44)];
        //commentLabel.text = @"Comment";
        //[self addSubview:commentLabel];
        
        //commentField
        commentField = [[UITextView alloc]initWithFrame:CGRectMake(10, 95, 300, 80)];
        //[self.commentField resignFirstResponder];
        commentField.textColor = [UIColor lightGrayColor];
        commentField.text = @"How was it? Leave a note...";
        commentField.font = [UIFont fontWithName:@"Helvetica Neue" size:16];
        commentField.textAlignment = 0;
        commentField.clipsToBounds = YES;
        commentField.layer.cornerRadius = 2.0f;
        [self addSubview:commentField];
        
        //characterLabel
        characterLabel = [[UILabel alloc]initWithFrame:CGRectMake(commentField.frame.size.width-10, commentField.frame.size.height+79, 30, 15)];
        characterLabel.text = @"140";
        characterLabel.font = [UIFont fontWithName:@"Helvetica Neue" size:10];
        characterLabel.textColor = [UIColor lightGrayColor];
        [self addSubview:characterLabel];

        //rateButton

        rateButton = [[UIButton alloc]initWithFrame:CGRectMake(10, 235, 300, 40)];
        [rateButton setTitle:@"Rate" forState:UIControlStateNormal];
        rateButton.layer.cornerRadius = 2.0f;
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
                if (!error && count > 0) {
                    NSLog(@"Den här filmen har betygsatts av den här personen");
                } else {
                    NSLog(@"Den här filmen har inte betygsatts av den här personen");
                }
            }];
        }
    }
    return self;
}

-(void)saveRating:(id)sender {
    PFUser *currentUser = [PFUser currentUser];
    if (currentUser) {
        NSString *test = [NSString stringWithFormat:@"%@",self.movieID];
        NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
        [f setNumberStyle:NSNumberFormatterDecimalStyle];
        NSNumber *myNumber = [f numberFromString:sliderLabel.text];
        
        PFQuery *query = [PFQuery queryWithClassName:@"Rating"];
        [query whereKey:@"user" equalTo:currentUser.username];
        [query whereKey:@"movieId" equalTo:test];
        [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
            if (object){
                object[@"comment"] = commentField.text;
                object[@"rating"] = myNumber;
                [object saveInBackground];
            } else {
                PFObject *rating = [PFObject objectWithClassName:@"Rating"];
                rating[@"user"] = currentUser.username;
                rating[@"comment"] = commentField.text;
                rating[@"rating"] = myNumber;
                rating[@"movieId"] = [NSString stringWithFormat:@"%@", self.movieID];
                [rating saveInBackground];

            }
        }];
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
                    commentField.text = [object objectForKey:@"comment"];
                    [rateButton setTitle:@"Update rating" forState:UIControlStateNormal];
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
