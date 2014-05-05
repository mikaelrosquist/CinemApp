//
//  LikeModel.h
//  CinemApp
//
//  Created by Teodor Östlund on 2014-05-05.
//  Copyright (c) 2014 Rosquist Östlund. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Parse/Parse.h"

@interface LikeModel : NSObject

- (BOOL) isLiking: (PFUser *)user :(NSString *) movieID;

- (void) addLike: (PFUser *)user :(NSString *) movieID :(NSString *)toUser;

- (void) delLike: (PFUser *)user :(NSString *) movieID;

@end
