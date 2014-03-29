//
//  User.h
//  TwitterHW
//
//  Created by Nathan Speller on 3/29/14.
//  Copyright (c) 2014 Nathan Speller. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

extern NSString *const UserDidLogin;
extern NSString *const UserDidLogout;

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong) NSString *screenName;
@property (nonatomic, strong) NSString *profileImageURL;

+ (User *)currentUser;
+ (void)setCurrentUser:(User *)user;

- (User *)initWithDictionary:(NSDictionary *)dict;

@end
