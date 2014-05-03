//
//  ActivityTableViewCell.m
//  CinemApp
//
//  Created by mikael on 29/04/14.
//  Copyright (c) 2014 Rosquist Östlund. All rights reserved.
//

#import "ActivityTableViewCell.h"

@implementation ActivityTableViewCell

@synthesize movieTitleLabel, userLabel, ratingLabel, commentView, posterView, rateStar;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        posterView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 67.5, 101.25)];
        movieTitleLabel = [[UILabel alloc]init];
        userLabel = [[UILabel alloc]initWithFrame:CGRectMake(110, 80, 100, 30)];
        rateStar = [[UIImageView alloc]init];
        ratingLabel = [[UILabel alloc]init];
        commentView = [[UITextView alloc]initWithFrame:CGRectMake(110, 40, 240, 30)];
        
        rateStar.image = [UIImage imageNamed:@"rate_star"];
        
        [ratingLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:28]];
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
