//
//  ActivityTableViewCell.h
//  CinemApp
//
//  Created by mikael on 29/04/14.
//  Copyright (c) 2014 Rosquist Östlund. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ActivityTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *movieTitleLabel;
@property (nonatomic, strong) UILabel *userLabel;
@property (nonatomic, strong) UITextView *commentView;
@property (nonatomic, strong) UILabel *ratingLabel;
@property (nonatomic, strong) UIImageView *posterView;
@property (nonatomic, strong) UIImageView *rateStar;


@end
