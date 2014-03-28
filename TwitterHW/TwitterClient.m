//
//  TwitterClient.m
//  TwitterHW
//
//  Created by Nathan Speller on 3/27/14.
//  Copyright (c) 2014 Nathan Speller. All rights reserved.
//

#import "TwitterClient.h"
#import "BDBOAuth1RequestOperationManager.h"

@implementation TwitterClient

+ (TwitterClient *)instance {
    static TwitterClient *instance = nil;
    static dispatch_once_t pred;
    
    dispatch_once(&pred, ^{
        instance = [[TwitterClient alloc] initWithBaseURL:[NSURL URLWithString:@"https://api.twitter.com"] consumerKey:@"YaLUcgOwPu31kDsvVueZPA" consumerSecret:@"6pNa6a4n074XDdiuuH1BL68xtZvkmrtoq2aZTjKfo"];
    });
    
    return instance;
}

- (void)login {
//    [self.requestSerializer removeAccessToken];
    [self fetchRequestTokenWithPath:@"oauth/request_token" method:@"POST" callbackURL:[NSURL URLWithString:@"ncstwitter://oauth"] scope:nil success:^(BDBOAuthToken *requestToken) {
        NSLog(@"Got the Request Token");
        NSString *authURL = [NSString stringWithFormat:@"https://apitwitter.com/oauth/authorize?oauth_token=%@", requestToken.token];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:authURL]];
    } failure:^(NSError *error) {
        NSLog(@"Failure %@", error.description);
    }];
}

@end