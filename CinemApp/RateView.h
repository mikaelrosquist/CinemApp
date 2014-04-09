//
//  RateView.h
//  CinemApp
//
//  Created by mikael on 18/02/14.
//  Copyright (c) 2014 Rosquist Östlund. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RateView : UIView

-(id)initWithMovieID:(CGRect)frame
                    :(NSString *)movieID;

//@property (nonatomic, weak) UILabel *sliderLabel;
@property (nonatomic, retain) UIImageView *sliderLabelBGView;
@property (nonatomic, strong) UITextView *commentField;
@property (nonatomic, strong) NSString *movieID;



@end
