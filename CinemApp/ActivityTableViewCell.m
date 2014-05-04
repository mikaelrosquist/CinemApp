//
//  ActivityTableViewCell.m
//  CinemApp
//
//  Created by mikael on 29/04/14.
//  Copyright (c) 2014 Rosquist Östlund. All rights reserved.
//

#import "ActivityTableViewCell.h"

@implementation ActivityTableViewCell

@synthesize movieTitleLabel, userLabel, ratingLabel, commentLabel, posterView, rateStar, userImageView, timeLabel, commentButton, likeButton;

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
        
        [commentButton setTitle:@"Comment" forState:UIControlStateNormal];
        commentButton.backgroundColor = [UIColor colorWithRed:0.855 green:0.243 blue:0.251 alpha:1];
        
        [likeButton setTitle:@"Like" forState:UIControlStateNormal];
        likeButton.backgroundColor = [UIColor colorWithRed:0.855 green:0.243 blue:0.251 alpha:1];
        
        rateStar.image = [UIImage imageNamed:@"rate_star"];
        
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
        
        /*
        [self.contentView addSubview:userLabel];
        [self.contentView addSubview:movieTitleLabel];
        [self.contentView addSubview:rateStar];
        [self.contentView addSubview:ratingLabel];
      //  [self.contentView addSubview:commentView];
        [self.contentView addSubview:posterView];
        */
    }
    return self;
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

@end
