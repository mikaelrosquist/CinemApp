//
//  MovieTableView.h
//  CinemApp
//
//  Created by mikael on 08/04/14.
//  Copyright (c) 2014 Rosquist Östlund. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MovieTableView.h"
#import "MovieView.h"

@interface MovieTableView : UITableView

- (id)initWithData:(CGRect)frame :(NSArray *)castArray;

@end
