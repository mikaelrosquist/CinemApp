//
//  ActivityTableViewCell.h
//  CinemApp
//
//  Created by mikael on 29/04/14.
//  Copyright (c) 2014 Rosquist Östlund. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LikeModel.h"

@interface ActivityTableViewCell : UITableViewCell{
    LikeModel *likeModel;
}


@property (nonatomic, retain) NSString *rateID;
@property (nonatomic, retain) NSString *toUserID;
@property (nonatomic, retain) NSString *cellID;

@property (nonatomic, strong) UILabel *userLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *movieTitleLabel;
@property (nonatomic, strong) UILabel *ratingLabel;
@property (nonatomic, strong) UILabel *commentLabel;

@property (nonatomic, strong) UIImageView *posterView;
@property (nonatomic, strong) UIImageView *rateStar;
@property (nonatomic, strong) UIImageView *userImageView;

@property (nonatomic, strong) UIButton *commentButton;
@property (nonatomic, strong) UIButton *likeButton;

@property (nonatomic, retain) LikeModel *likeModel;

//- (void)updateButton;


@end
