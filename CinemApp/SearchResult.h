//
//  SearchResult.h
//  CinemApp
//
//  Created by Teodor Östlund on 2014-04-03.
//  Copyright (c) 2014 Rosquist Östlund. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SearchResult : NSObject
    @property (nonatomic, strong) NSString *movieTitle;
    @property (nonatomic, strong) NSString *movieReleaseDate;
    @property (nonatomic, strong) UIImage *moviePoster;
@end
