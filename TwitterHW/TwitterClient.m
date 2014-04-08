//
//  TwitterClient.m
//  TwitterHW
//
//  Created by Nathan Speller on 3/27/14.
//  Copyright (c) 2014 Nathan Speller. All rights reserved.
//

#import "TwitterClient.h"
#import "BDBOAuth1RequestOperationManager.h"
#import "User.h"

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
    [self.requestSerializer removeAccessToken];
    [self fetchRequestTokenWithPath:@"oauth/request_token" method:@"POST" callbackURL:[NSURL URLWithString:@"ncstwitter://oauth"] scope:nil success:^(BDBOAuthToken *requestToken) {
        NSLog(@"Got the Request Token");
        NSString *authURL = [NSString stringWithFormat:@"https://api.twitter.com/oauth/authorize?oauth_token=%@", requestToken.token];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:authURL]];
    } failure:^(NSError *error) {
        NSLog(@"Failure %@", error.description);
    }];
}

- (AFHTTPRequestOperation *) verifyCredentialsWithSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                                  failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    return [self GET:@"1.1/account/verify_credentials.json" parameters:nil success:success failure:failure];
}

- (AFHTTPRequestOperation *)homeTimeLineWithSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                            failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;{
    return [self GET:@"1.1/statuses/home_timeline.json" parameters:nil success:success failure:failure];
}

- (AFHTTPRequestOperation *)mentionsWithSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                            failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;{
    return [self GET:@"1.1/statuses/mentions_timeline.json" parameters:nil success:success failure:failure];
}

- (AFHTTPRequestOperation *)userTimeLine:(User *)user success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                            failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;{
    return [self GET:@"1.1/statuses/user_timeline.json" parameters:@{@"screen_name":user.screenName} success:success failure:failure];
}

- (AFHTTPRequestOperation *)tweetStatus:(NSString *)tweet inReplyToStatusId:(NSString *)inReplyToStatusId success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;{
    NSDictionary *parameters;
    if (inReplyToStatusId){
        parameters = @{@"status":tweet, @"in_reply_to_status_id":inReplyToStatusId};
    } else {
        parameters = @{@"status":tweet};
    }
    
    return [self POST:@"1.1/statuses/update.json" parameters:parameters success:success failure:failure];
}

- (AFHTTPRequestOperation *) retweetTweet:(NSString *)tweetId success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    
    return [self POST:[NSString stringWithFormat:@"1.1/statuses/retweet/%@.json", tweetId] parameters:nil success:success failure:failure];
}

- (AFHTTPRequestOperation *) favoriteTweet:(NSString *)tweetId success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    
    return [self POST:@"1.1/favorites/create.json" parameters:@{@"id":tweetId} success:success failure:failure];
}

- (AFHTTPRequestOperation *) unfavoriteTweet:(NSString *)tweetId success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    
    return [self POST:@"1.1/favorites/destroy.json" parameters:@{@"id":tweetId} success:success failure:failure];
}

@end
