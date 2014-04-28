//
//  MovieView.h
//  CinemApp
//
//  Created by Teodor Östlund on 2014-02-18.
//  Copyright (c) 2014 Rosquist Östlund. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MovieTableView;
@class MovieTableViewController;

@interface MovieView : UIView

-(id)initWithMovieInfo:(CGRect)frame
                      :(NSData*)posterImage
                      :(NSString *)moviePlot
                      :(UIView *)castTableView;

@property (nonatomic, strong) NSString *plotText;
@property (nonatomic, strong) UITextView *plotView;
@property (nonatomic, strong) UIImageView *posterView;
@property (nonatomic, strong) NSData *posterImage;
@property (nonatomic, strong) UILabel *castLabel;
@property (nonatomic, strong) UITableView *castTable;

- (void)textViewDidChange:(UITextView *)textView;

@end
