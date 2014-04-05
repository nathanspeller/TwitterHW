//
//  AppDelegate.h
//  TwitterHW
//
//  Created by Nathan Speller on 3/27/14.
//  Copyright (c) 2014 Nathan Speller. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginViewController.h"
#import "TimelineViewController.h"
#import "HamburgerViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) LoginViewController *loginVC;
@property (strong, nonatomic) HamburgerViewController *hamburgerVC;

@end
