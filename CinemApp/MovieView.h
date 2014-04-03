//
//  TestView.h
//  CinemApp
//
//  Created by Teodor Östlund on 2014-02-18.
//  Copyright (c) 2014 Rosquist Östlund. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import <JLTMDbClient.h>

@interface MovieView : UIView

-(id)initWithMovieInfo:(CGRect)frame
                      :(NSData*)posterImage
                      :(NSString *)moviePlot;

@property (nonatomic, strong) NSString *plotText;
@property (nonatomic, strong) UITextView *plotView;
@property (nonatomic, strong) NSData *posterImage;

- (void)textViewDidChange:(UITextView *)textView;

@end
