//
//  Tweet.h
//  TwitterHW
//
//  Created by Nathan Speller on 3/28/14.
//  Copyright (c) 2014 Nathan Speller. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Tweet : NSObject
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSDate *timestamp;
@property (nonatomic, strong) NSURL    *userImage;
@property (nonatomic, strong) NSString *tweetId;
@property (nonatomic,assign)  NSUInteger favorited;
@property (nonatomic,assign)  NSUInteger retweeted;
@property (nonatomic,assign)  NSUInteger favoriteCount;
@property (nonatomic,assign)  NSUInteger retweetCount;

- (Tweet *)initWithDictionary:(NSDictionary *)dict;
@end
