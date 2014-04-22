//
//  RateView.m
//  CinemApp
//
//  Created by mikael on 18/02/14.
//  Copyright (c) 2014 Rosquist Östlund. All rights reserved.
//

#import "RateView.h"
#import "Parse/Parse.h"
#import "DejalActivityView.h"

@implementation RateView{
    UILabel *sliderLabel;
    UISlider *slider;
    UIButton *rateButton;
}

@synthesize commentField, movieID, characterLabel, placeholder;

-(id)initWithMovieID:(CGRect)frame :(NSString *)incomingMovieID
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.movieID = incomingMovieID;
        [self checkIfRated:self.movieID];
        
        //slider
        CGRect frame = CGRectMake(10, 65, 260, 15);
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
        self.sliderLabelBGView.frame = CGRectMake(280, 57, 30, 30);
        [self addSubview:self.sliderLabelBGView];
        
        //sliderLabel
        sliderLabel = [[UILabel alloc]initWithFrame:CGRectMake(285, 50, 20, 44)];
        sliderLabel.textColor = [UIColor whiteColor];
        sliderLabel.font = [UIFont fontWithName:@"Helvetica Neue-Bold" size:16];
        sliderLabel.textAlignment = NSTextAlignmentCenter;
        sliderLabel.text = @"5";
        [self addSubview:sliderLabel];
        
        //visa i feed-switchen
        UILabel *feedLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 190, 100, 44)];
        feedLabel.text = @"Show in feed";
        [self addSubview:feedLabel];
        UISwitch *feedSwitch = [[UISwitch alloc]initWithFrame:CGRectMake(258, 200, 40, 20)];
        feedSwitch.onTintColor = [UIColor colorWithRed:0.855 green:0.243 blue:0.251 alpha:1];
        [feedSwitch setOn:YES];
        [self addSubview:feedSwitch];
        
        //commentLabel
        //UILabel *commentLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 150, 100, 44)];
        //commentLabel.text = @"Comment";
        //[self addSubview:commentLabel];
        
        //commentField
        placeholder = @"How was it? Leave a note...";
        commentField = [[UITextView alloc]initWithFrame:CGRectMake(10, 105, 300, 80)];
        commentField.textColor = [UIColor lightGrayColor];
        commentField.text = placeholder;
        commentField.font = [UIFont fontWithName:@"Helvetica Neue" size:16];
        commentField.textAlignment = 0;
        commentField.clipsToBounds = YES;
        commentField.layer.cornerRadius = 2.0f;
        [self addSubview:commentField];
        
        //characterLabel
        characterLabel = [[UILabel alloc]initWithFrame:CGRectMake(commentField.frame.size.width-13, commentField.frame.size.height+90, 20, 15)];
        characterLabel.text = @"140";
        characterLabel.font = [UIFont fontWithName:@"Helvetica Neue" size:10];
        characterLabel.textColor = [UIColor lightGrayColor];
        characterLabel.textAlignment = UITextAlignmentRight;
        [self addSubview:characterLabel];

        //rateButton
        rateButton = [[UIButton alloc]initWithFrame:CGRectMake(10, 245, 300, 40)];
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
    
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"PassData"
     object:nil];
    
    [DejalBezelActivityView activityViewForView:self];
    
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
                [object deleteInBackground];
            } else {
                PFObject *rating = [PFObject objectWithClassName:@"Rating"];
                rating[@"user"] = currentUser.username;
                if(commentField.text == placeholder) //Kollar endast minnesadressen och inte texten. Man kan alltså skriva in exakt likadan text som placeholdern och det kommer då bli en kommentar. Tycker det är snyggare än att använda [commentField.text isEqualToString:placeholder].
                    rating[@"comment"] = NULL; //Vet inte vad som ska hända om ingen kommentar skrivs.
                else
                    rating[@"comment"] = commentField.text;
                rating[@"rating"] = myNumber;
                rating[@"movieId"] = [NSString stringWithFormat:@"%@", self.movieID];
                [rating saveInBackground];
            }
            [DejalBezelActivityView removeViewAnimated:YES];
        }];
        NSLog(@"Rating sparas...");
    }else{
        NSLog(@"Inte inloggad!");
    }
    
}

- (void)sliderAction:(id)sender {
    NSInteger val = lround(slider.value);
    sliderLabel.text = [NSString stringWithFormat:@"%ld",(long)val];
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
                    sliderLabel.text = [NSString stringWithFormat:@"%ld",(long)val];
                    commentField.text = [object objectForKey:@"comment"];
                    [rateButton setTitle:@"Remove rating" forState:UIControlStateNormal];
                    rateButton.backgroundColor = [UIColor darkGrayColor];
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
