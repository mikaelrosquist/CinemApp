//
//  LikeModel.m
//  CinemApp
//
//  Created by Teodor Östlund on 2014-05-05.
//  Copyright (c) 2014 Rosquist Östlund. All rights reserved.
//

#import "LikeModel.h"

@implementation LikeModel

- (BOOL) isLiking: (PFUser *)user :(NSString *) ratingID{
    
    
    PFQuery *query = [PFQuery queryWithClassName:@"Like"];
    [query whereKey:@"userId" equalTo:user.objectId];
    [query whereKey:@"ratingId" equalTo:ratingID];

    if([query getFirstObject] != nil)
        return YES;
    else
        return NO;
}

- (void) addLike: (PFUser *)user :(NSString *) ratingID :(NSString *)toUser{
    PFObject *like = [PFObject objectWithClassName:@"Like"];
    like[@"userId"] = user.objectId;
    like[@"ratingId"] = ratingID;
    [like saveInBackground];
    
    NSLog(@"Like sparad");
    
    
    PFQuery *innerQuery = [PFUser query];
    [innerQuery whereKey:@"objectId" equalTo:toUser];
    [innerQuery whereKey:@"notifications" equalTo:@YES];
    NSLog(@"%i", [innerQuery countObjects]);
    PFQuery *pushQuery = [PFInstallation query];
    [pushQuery whereKey:@"user" matchesQuery:innerQuery];
    
    
    NSDictionary *data = @{
                           @"alert": [NSString stringWithFormat:@"%@ has liked one of your ratings!", user.username],
                           @"userId": user.objectId,
                           @"badge": @"Increment",
                           @"sound": @""
                           };
    
    // Send push notification to query
    PFPush *push = [[PFPush alloc] init];
    [push setQuery:pushQuery]; // Set our Installation query
    [push setMessage:[NSString stringWithFormat:@"%@ has liked one of your ratings!", user.username]];
    [push setData:data];
    [push sendPushInBackground];

    
    
    
    /* HAR MED NOTIFIKATIONER ATT GÖRA. FIXA SEN
    
    PFQuery *query = [PFQuery queryWithClassName:@"Rating"];
    [query whereKey:@"objectId" equalTo:ratingID];
    [query getFirstObject];
    
    if([query getFirstObject] != nil)
        return YES;
    else
        return NO;

    
    
    PFQuery *innerQuery = [PFUser query];
    [innerQuery whereKey:@"objectId" equalTo:user.objectId];
    [innerQuery whereKey:@"notifications" equalTo:@YES];
    NSLog(@"%i", [innerQuery countObjects]);
    PFQuery *pushQuery = [PFInstallation query];
    [pushQuery whereKey:@"user" matchesQuery:innerQuery];
    
    
    // Create our Installation query
    PFQuery *innerQuery = [PFQuery queryWithClassName:@"Rating"];
    [innerQuery whereKey:@"user" equalTo:user.username];
    [innerQuery whereKey:@"movieId" equalTo:movieID];
    
    PFQuery *innerInnerQuery = [PFUser query];
    [pushQuery whereKey:@"installationUser" matchesQuery:innerQuery];

    PFQuery *pushQuery = [PFInstallation query];
    [pushQuery whereKey:@"user" matchesQuery:innerQuery];
    
    [innerQuery whereKey:@"notifications" equalTo:@YES];
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
     */
    
}

- (void) delLike: (PFUser *)user :(NSString *) movieID{
    PFQuery *query = [PFQuery queryWithClassName:@"Like"];
    [query whereKey:@"userId" equalTo:user.objectId];
    [query whereKey:@"movieId" equalTo:movieID];
    [[query getFirstObject] deleteInBackground];
    
    NSLog(@"Like är borttagen");
}

@end
