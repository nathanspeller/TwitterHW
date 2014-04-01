//
//  ComposeTweetViewController.h
//  TwitterHW
//
//  Created by Nathan Speller on 3/29/14.
//  Copyright (c) 2014 Nathan Speller. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"

@class ComposeTweetViewController;
@protocol ComposeTweetViewControllerDelegate <NSObject>
- (void)addTweet:(Tweet *)tweet controller:(ComposeTweetViewController *)controller;
@end

@interface ComposeTweetViewController : UIViewController <UITextViewDelegate>
@property (nonatomic, strong) NSString *pretweetContent;
@property (nonatomic, strong) NSString *inReplyToStatusId;
@property (nonatomic, weak) id <ComposeTweetViewControllerDelegate> delegate;
@end
