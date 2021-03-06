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
    if (currentUser == nil){
        NSDictionary *dict = [[NSUserDefaults standardUserDefaults] objectForKey:@"savedCurrentUserKey"];
        if (dict){
            currentUser = [[User alloc] initWithDictionary:dict];
        }
    }
    return currentUser;
}

+ (void)setCurrentUser:(User *)user{
    currentUser = user;
    [currentUser saveCurrentUser];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"UserDidLogin" object:nil];
}

+ (void)logoutUser{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"savedCurrentUserKey"];
    currentUser = nil;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"UserDidLogout" object:nil];
    NSLog(@"%@", [[NSUserDefaults standardUserDefaults] objectForKey:@"savedCurrentUserKey"]);
}

- (User *)initWithDictionary:(NSDictionary *)dict{
    self = [super self];
    if (self) {
        if (dict[@"id"]) {
            self.name = dict[@"name"];
            self.userId = dict[@"id"];
            self.screenName = dict[@"screen_name"];
            self.profileImageURL = dict[@"profile_image_url"];
            NSString *bannerTemp = dict[@"profile_banner_url"];
            if ([bannerTemp length] == 0) {
                self.bannerImageURL = @"https://abs.twimg.com/a/1396545424/img/t1/grey_header_web.jpg";
            } else if ([bannerTemp rangeOfString:@"pbs.twimg.com"].location == NSNotFound){
                self.bannerImageURL = bannerTemp;
            } else {
                self.bannerImageURL = [NSString stringWithFormat:@"%@/web", bannerTemp];
            }
        } else {
            self = nil;
        }
    }
    return self;
}

- (void) saveCurrentUser {
    NSDictionary *saveUser = @{
                               @"name":              self.name,
                               @"id":                self.userId,
                               @"screen_name":       self.screenName,
                               @"profile_image_url": self.profileImageURL,
                               @"banner_image_url" : self.bannerImageURL
                               };
    
    [[NSUserDefaults standardUserDefaults] setObject:saveUser forKey:@"savedCurrentUserKey"];
}

@end
