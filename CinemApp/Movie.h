//
//  City.h
//  JSONiOS
//
//  Created by Kurup, Vishal on 4/14/13.
//  Copyright (c) 2013 conkave. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Movie : NSObject

@property (nonatomic, strong) NSString * movieID;
@property (nonatomic, strong) NSString * movieName;
@property (nonatomic, strong) NSString * movieRelease;
@property (nonatomic, strong) NSString * movieGenre;
@property (nonatomic, strong) NSString * movieRuntime;
@property (nonatomic, strong) NSString * movieBackgroundImageURL;


//Methods
- (id) initWithMovieID: (NSString *) mID andMovieName: (NSString *) mName andMovieRelease: (NSString *) mRelease andMovieGenre: (NSString *) mGenre andMovieRuntime: (NSString *) mRuntime andMovieBackgroundImageURL: (NSString *) mBackground;

@end
