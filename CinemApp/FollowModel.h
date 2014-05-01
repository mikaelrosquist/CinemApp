//
//  FollowButtonModel.h
//  CinemApp
//
//  Created by Teodor Östlund on 2014-05-01.
//  Copyright (c) 2014 Rosquist Östlund. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Parse/Parse.h"

@interface FollowModel : NSObject

- (BOOL) isFollowing: (PFUser *)user1 :(PFUser *)user2;

- (void) addFollower: (PFUser *)user1 :(PFUser *)user2;

- (void) delFollower: (PFUser *)user1 :(PFUser *)user2;

@end
