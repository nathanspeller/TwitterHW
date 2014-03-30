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
    self.username = dict[@"user"][@"name"];
    self.content = dict[@"text"];
    return self;
}
@end
