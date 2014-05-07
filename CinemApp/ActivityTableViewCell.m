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

@synthesize movieTitleLabel, userLabel, ratingLabel, commentLabel, posterView, rateStar, userImageView, timeLabel, commentButton, likeButton, rateID, toUserID, likeModel, cellID;

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
        cellID = [[NSString alloc]init];
        
        //Buttons
        commentButton = [[UIButton alloc]init];
        likeButton = [[UIButton alloc]init];
        
        

        //[[likeButton layer] setBorderColor:[UIColor grayColor].CGColor];
        likeButton.backgroundColor = [UIColor lightGrayColor];
        
        [commentButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:12.0]];
        [commentButton setTitleColor:[UIColor colorWithRed:0.482 green:0.482 blue:0.482 alpha:1] forState:UIControlStateNormal];
        [[commentButton layer] setCornerRadius:3.0f];
        commentButton.backgroundColor = [UIColor colorWithRed:0.867 green:0.867 blue:0.867 alpha:1];
        [commentButton setTitle:@"Comment" forState:UIControlStateNormal];
        [commentButton setImage: [UIImage imageNamed:@"commentBtn"] forState:UIControlStateNormal];
        [commentButton setImageEdgeInsets:UIEdgeInsetsMake(3.0, 3.0, 3.0, 69.0)];
        [commentButton setTitleEdgeInsets:UIEdgeInsetsMake(0.0, -10.0, 0.0, 0.0)];
        [commentButton setAlpha:0.3];
        

        [likeButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:12.0]];
        [likeButton addTarget:self action:@selector(setBgColorForButton:) forControlEvents:UIControlEventTouchDown];
        [likeButton addTarget:self action:@selector(clearBgColorForButton:) forControlEvents:UIControlEventTouchDragExit];
        [likeButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [likeButton setTitleColor:[UIColor colorWithRed:0.482 green:0.482 blue:0.482 alpha:1] forState:UIControlStateNormal];
        [[likeButton layer] setCornerRadius:3.0f];
        likeButton.backgroundColor = [UIColor colorWithRed:0.867 green:0.867 blue:0.867 alpha:1];
        [likeButton setTitle:@"Like" forState:UIControlStateNormal];
        [likeButton setImage: [UIImage imageNamed:@"likeBtn-0"] forState:UIControlStateNormal];
        [likeButton setImageEdgeInsets:UIEdgeInsetsMake(3.0, 3.0, 3.0, 44.0)];
        [likeButton setTitleEdgeInsets:UIEdgeInsetsMake(0.0, -13.0, 0.0, 0.0)];
        
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

- (void) likePost{
    
    NSMutableDictionary* userInfo = [NSMutableDictionary dictionary];
    [userInfo setObject:[PFUser currentUser].objectId forKey:@"user"];
    [userInfo setObject:rateID forKey:@"rating"];
    [userInfo setObject:toUserID forKey:@"toUser"];
    [userInfo setObject:cellID forKey:@"cellID"];
    
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
    if([[sender currentTitle]  isEqual: @"Like"]){
        [sender setTitle:@"Liked" forState:UIControlStateNormal];
        [sender setImage: [UIImage imageNamed:@"likeBtn-1"] forState:UIControlStateNormal];
        [sender setBackgroundColor:[UIColor colorWithRed:0.769 green:0.769 blue:0.769 alpha:1]];
        [sender setTitleEdgeInsets:UIEdgeInsetsMake(0.0, -30.0, 0.0, 0.0)];
    }else if([[sender currentTitle]  isEqual: @"Liked"]){
        [sender setTitle:@"Like" forState:UIControlStateNormal];
        [sender setImage: [UIImage imageNamed:@"likeBtn-0"] forState:UIControlStateNormal];
        [sender setBackgroundColor:[UIColor colorWithRed:0.867 green:0.867 blue:0.867 alpha:1]];
        [sender setTitleEdgeInsets:UIEdgeInsetsMake(0.0, -13.0, 0.0, 0.0)];
    }
    [self likePost];
}

@end
