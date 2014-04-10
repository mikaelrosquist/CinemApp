//
//  TestView.h
//  CinemApp
//
//  Created by Teodor Östlund on 2014-02-18.
//  Copyright (c) 2014 Rosquist Östlund. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MovieTableView.h"
#import "MovieTableViewController.h"
//#import <JLTMDbClient.h>

@interface MovieView : UIView

-(id)initWithMovieInfo:(CGRect)frame
                      :(NSData*)posterImage
                      :(NSString *)moviePlot
                      :(UITableView *)castTable;

@property (nonatomic, strong) NSString *plotText;
@property (nonatomic, strong) UITextView *plotView;
@property (nonatomic, strong) UIImageView *posterView;
@property (nonatomic, strong) NSData *posterImage;
@property (nonatomic, strong) UILabel *castLabel;
@property (nonatomic, strong) UIImageView *personView;
@property (nonatomic, strong) UITableView *castTable;

- (void)textViewDidChange:(UITextView *)textView;

@end
