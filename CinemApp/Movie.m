//
//  City.m
//  JSONiOS
//
//  Created by Kurup, Vishal on 4/14/13.
//  Copyright (c) 2013 conkave. All rights reserved.
//

#import "Movie.h"

@implementation Movie
@synthesize movieID, movieName, movieRelease, movieGenre, movieRuntime, movieBackgroundImageURL;

- (id) initWithMovieID: (NSString *) mID andMovieName: (NSString *) mName andMovieRelease: (NSString *) mRelease andMovieGenre: (NSString *) mGenre andMovieRuntime: (NSString *) mRuntime andMovieBackgroundImageURL: (NSString *) mBackground
{
    self = [super init];
    if (self)
    {
        movieID = mID;
        movieName = mName;
        movieRelease = mRelease;
        movieGenre = mGenre;
        movieRuntime = mRuntime;
        movieBackgroundImageURL = mBackground;
    }
    
    return self;
}

@end
