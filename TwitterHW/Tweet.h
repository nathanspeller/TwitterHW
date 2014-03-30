//
//  Tweet.h
//  TwitterHW
//
//  Created by Nathan Speller on 3/28/14.
//  Copyright (c) 2014 Nathan Speller. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Tweet : NSObject
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *content;

- (Tweet *)initWithDictionary:(NSDictionary *)dict;
@end
