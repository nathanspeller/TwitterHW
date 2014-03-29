//
//  User.m
//  TwitterHW
//
//  Created by Nathan Speller on 3/29/14.
//  Copyright (c) 2014 Nathan Speller. All rights reserved.
//

#import "User.h"

@implementation User

static User *currentUser = nil;

+ (User *)currentUser{
    return currentUser;
}

+ (void)setCurrentUser:(User *)user{
    currentUser = user;
}

- (User *)initWithDictionary:(NSDictionary *)dict{
    self = [super self];
    if (self) {
        if (dict[@"id"]) {
            self.name = dict[@"name"];
            self.userId = dict[@"id"];
            self.screenName = dict[@"screen_name"];
            self.profileImageURL = dict[@"profile_image_url"];
            NSLog(@"initWithDictionary USER");
        } else {
            self = nil;
        }
    }
    return self;
}

@end
