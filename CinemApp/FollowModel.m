//
//  FollowButtonModel.m
//  CinemApp
//
//  Created by Teodor Östlund on 2014-05-01.
//  Copyright (c) 2014 Rosquist Östlund. All rights reserved.
//

#import "FollowModel.h"

@implementation FollowModel

- (BOOL) isFollowing: (PFUser *)user1 :(PFUser *)user2{
    
    
    PFQuery *query = [PFQuery queryWithClassName:@"Follow"];
    [query whereKey:@"userId" equalTo:user1.objectId];
    [query whereKey:@"followsId" equalTo:user2.objectId];
    [query getFirstObject];
    
    if([query getFirstObject] != nil)
        return YES;
    else
        return NO;
}

- (void) addFollower: (PFUser *)user1 :(PFUser *)user2{
    
}

- (void) delFollower: (PFUser *)user1 :(PFUser *)user2{
    
}

@end
