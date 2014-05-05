//
//  ActivityTableViewCell.m
//  CinemApp
//
//  Created by mikael on 29/04/14.
//  Copyright (c) 2014 Rosquist Östlund. All rights reserved.
//

#import "ActivityTableViewCell.h"
#import "Parse/Parse.h"

@implementation ActivityTableViewCell

@synthesize movieTitleLabel, userLabel, ratingLabel, commentLabel, posterView, rateStar, userImageView, timeLabel, commentButton, likeButton, rateID, toUserID, likeModel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //Labels och Views
        posterView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 50, 67.5, 101.25)];
        userImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 30, 30)];
        userLabel = [[UILabel alloc]initWithFrame:CGRectMake(50, 15, 150, 20)];
        timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(210, 16, 100, 20)];
        movieTitleLabel = [[UILabel alloc]init];
        rateStar = [[UIImageView alloc]init];
        ratingLabel = [[UILabel alloc]init];
        commentLabel = [[UILabel alloc]init];
        
        //Buttons
        commentButton = [[UIButton alloc]init];
        likeButton = [[UIButton alloc]init];
        [likeButton addTarget:self action:@selector(likePost) forControlEvents:UIControlEventTouchUpInside];
        [likeButton addTarget:self action:@selector(setBgColorForButton:) forControlEvents:UIControlEventTouchDown];
        [likeButton addTarget:self action:@selector(clearBgColorForButton:) forControlEvents:UIControlEventTouchDragExit];
        [likeButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
        

        //[[likeButton layer] setBorderColor:[UIColor grayColor].CGColor];
        [likeButton setTitle:@"Loading" forState:UIControlStateNormal];
        likeButton.backgroundColor = [UIColor lightGrayColor];
        
        /*
            if([likedArray objectAtIndex:indexPath.row] == [NSNumber numberWithBool:YES]){
                [activityTableCell.likeButton setTitle:@"Liked" forState:UIControlStateNormal];
                activityTableCell.likeButton.backgroundColor = [UIColor greenColor];
            }else{
                [activityTableCell.likeButton setTitle:@"Like" forState:UIControlStateNormal];
                activityTableCell.likeButton.backgroundColor = [UIColor colorWithRed:0.855 green:0.243 blue:0.251 alpha:1];
            }
        */
        [commentButton setTitle:@"Comment" forState:UIControlStateNormal];
        commentButton.backgroundColor = [UIColor colorWithRed:0.855 green:0.243 blue:0.251 alpha:1];
        

        [commentButton setBackgroundImage:[UIImage imageNamed:@"speech_bubble-50"] forState:UIControlStateNormal];
        
        [likeButton setBackgroundImage:[UIImage imageNamed:@"like-50"] forState:UIControlStateNormal];
        
        rateStar.image = [UIImage imageNamed:@"star-75"];
        
        [userLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:14]];
        userLabel.textColor = [UIColor colorWithRed:0.855 green:0.243 blue:0.251 alpha:1];
        
        timeLabel.textAlignment = NSTextAlignmentRight;
        [timeLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:12]];
        timeLabel.textColor = [UIColor lightGrayColor];
        
        [commentLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:14]];
        commentLabel.numberOfLines = 4;
        commentLabel.textAlignment = NSTextAlignmentLeft;
        commentLabel.lineBreakMode = NSLineBreakByWordWrapping;
        
        [ratingLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:28]];
        ratingLabel.textAlignment = NSTextAlignmentLeft;
        
        movieTitleLabel.numberOfLines = 3;
        movieTitleLabel.textAlignment = NSTextAlignmentLeft;
        movieTitleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        [movieTitleLabel setFont:[UIFont fontWithName: @"HelveticaNeue-Light" size: 20.0]];
        
    }
    return self;
}
/*
- (void)updateButton{
    
    PFQuery *query = [PFQuery queryWithClassName:@"Like"];
    [query whereKey:@"userId" equalTo:[PFUser currentUser].objectId];
    [query whereKey:@"ratingId" equalTo:rateID];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (objects.count > 0){
            [likeButton setTitle:@"Liked" forState:UIControlStateNormal];
            likeButton.backgroundColor = [UIColor greenColor];
        }else{
            [likeButton setTitle:@"Like" forState:UIControlStateNormal];
            likeButton.backgroundColor = [UIColor colorWithRed:0.855 green:0.243 blue:0.251 alpha:1];
        }
    }];
}*/

- (void) likePost{
    
    NSMutableDictionary* userInfo = [NSMutableDictionary dictionary];
    [userInfo setObject:[PFUser currentUser].objectId forKey:@"user"];
    [userInfo setObject:rateID forKey:@"rating"];
    [userInfo setObject:toUserID forKey:@"toUser"];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:[NSString stringWithFormat:@"test"] object:self userInfo:userInfo];
}


- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setBgColorForButton:(UIButton*)sender
{
    [sender setAlpha:0.5];
}

-(void)clearBgColorForButton:(UIButton*)sender
{
    [sender setAlpha:1.0];
}

-(void)buttonPressed:(UIButton*)sender
{
    [sender setAlpha:1.0];
    [sender setBackgroundColor:[UIColor greenColor]];
    [sender setTitle:@"Liked" forState:UIControlStateNormal];
}

@end
