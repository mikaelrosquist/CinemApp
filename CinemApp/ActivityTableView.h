//
//  ActivityTableView.h
//  CinemApp
//
//  Created by mikael on 21/02/14.
//  Copyright (c) 2014 Rosquist Östlund. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ActivityTableViewCell.h"

@interface ActivityTableView : UITableView

@property (nonatomic, strong) ActivityTableViewCell *tableCell;

@end
