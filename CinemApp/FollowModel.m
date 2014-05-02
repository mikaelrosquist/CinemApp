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
    PFObject *follow = [PFObject objectWithClassName:@"Follow"];
    follow[@"userId"] = user1.objectId;
    follow[@"followsId"] = user2.objectId;
    [follow saveInBackground];
    
    // Create our Installation query
    
    PFQuery *innerQuery = [PFUser query];
    [innerQuery whereKey:@"objectId" equalTo:user2.objectId];
    [innerQuery whereKey:@"notifications" equalTo:@YES];
    NSLog(@"%i", [innerQuery countObjects]);
    PFQuery *pushQuery = [PFInstallation query];
    [pushQuery whereKey:@"user" matchesQuery:innerQuery];
    
    
    NSDictionary *data = @{
                           @"alert": [NSString stringWithFormat:@"%@ has started following you!", user1.username],
                           @"userId": user1.objectId,
                           @"badge": @"Increment",
                           @"sound": @""
                           };
    
    // Send push notification to query
    PFPush *push = [[PFPush alloc] init];
    [push setQuery:pushQuery]; // Set our Installation query
    [push setMessage:[NSString stringWithFormat:@"%@ has started following you!", user1.username]];
    [push setData:data];
    [push sendPushInBackground];
}

- (void) delFollower: (PFUser *)user1 :(PFUser *)user2{
    PFQuery *query = [PFQuery queryWithClassName:@"Follow"];
    [query whereKey:@"userId" equalTo:user1.objectId];
    [query whereKey:@"followsId" equalTo:user2.objectId];
    [[query getFirstObject] deleteInBackground];
    
    NSLog(@"%@ har nu avföljt %@", user1.username, user2.username);
}

@end