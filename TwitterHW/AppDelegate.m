//
//  AppDelegate.m
//  TwitterHW
//
//  Created by Nathan Speller on 3/27/14.
//  Copyright (c) 2014 Nathan Speller. All rights reserved.
//

#import "AppDelegate.h"
#import "TwitterClient.h"
#import "User.h"
#import "HamburgerViewController.h"

@implementation NSURL (dictionaryFromQueryString)

- (NSDictionary *)dictionaryFromQueryString
{
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    
    NSArray *pairs = [[self query] componentsSeparatedByString:@"&"];
    
    for(NSString *pair in pairs) {
        NSArray *elements = [pair componentsSeparatedByString:@"="];
        
        NSString *key = [[elements objectAtIndex:0] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString *val = [[elements objectAtIndex:1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        [dictionary setObject:val forKey:key];
    }
    
    return dictionary;
}

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self setRootViewController];
    [self subscribeToUserNotifications];
    [self.window makeKeyAndVisible];
    
    return YES;
}


- (void)setRootViewController {
    
    if (!self.loginVC){
        self.loginVC = [[LoginViewController alloc] init];
    }
    if (!self.hamburgerVC){
        self.hamburgerVC = [[HamburgerViewController alloc] init];
    }
    
    User *user = [User currentUser];

    if (user != nil) {
        self.window.rootViewController = self.hamburgerVC;
    } else {
        self.window.rootViewController = self.loginVC;
    }
}

- (void)subscribeToUserNotifications{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setRootViewController) name:@"UserDidLogin" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setRootViewController) name:@"UserDidLogout" object:nil];
}


- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    if ([url.scheme isEqualToString:@"ncstwitter"])
    {
        if ([url.host isEqualToString:@"oauth"])
        {
            NSDictionary *parameters = [url dictionaryFromQueryString];
            if (parameters[@"oauth_token"] && parameters[@"oauth_verifier"]) {
                TwitterClient *client = [TwitterClient instance];
                [client fetchAccessTokenWithPath:@"/oauth/access_token" method:@"POST" requestToken:[BDBOAuthToken tokenWithQueryString:url.query ] success:^(BDBOAuthToken *accessToken) {
                    NSLog(@"access token");
                    [client.requestSerializer saveAccessToken:accessToken];
                    
                    [client verifyCredentialsWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
                        // set the current user
                        User *user = [[User alloc] initWithDictionary:responseObject];
                        [User setCurrentUser:user];
                    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                        NSLog(@"FAIL");
                    }];
                    
                } failure:^(NSError *error) {
                    NSLog(@"failed to get access token");
                }];
            }
        }
        return YES;
    }
    return NO;
}

@end
