//
//  Tweet.m
//  TwitterHW
//
//  Created by Nathan Speller on 3/28/14.
//  Copyright (c) 2014 Nathan Speller. All rights reserved.
//

#import "Tweet.h"

@implementation Tweet
- (Tweet *)initWithDictionary:(NSDictionary *)dict{
    self = [super init];
    if (self) {
        self.name = dict[@"user"][@"name"];
        self.username = dict[@"user"][@"screen_name"];
        self.content = dict[@"text"];
        self.tweetId = dict[@"id"];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"eee MMM dd HH:mm:ss ZZZZ yyyy"];
        self.timestamp = [dateFormatter dateFromString:dict[@"created_at"]];
        
        self.userImage = [NSURL URLWithString:dict[@"user"][@"profile_image_url"]];
        self.favorited = [dict[@"favorited"] intValue];
        self.retweeted = [dict[@"retweeted"] intValue];
        self.retweetCount = [dict[@"retweet_count"] intValue];
        self.favoriteCount = [dict[@"favorite_count"] intValue];
    }
    return self;
}
@end
