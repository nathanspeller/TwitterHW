//
//  TimelineViewController.h
//  TwitterHW
//
//  Created by Nathan Speller on 3/28/14.
//  Copyright (c) 2014 Nathan Speller. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ComposeTweetViewController.h"

enum FeedType {
    TIMELINE,
    MENTIONS
};
typedef enum FeedType FeedType;

@interface ListViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, ComposeTweetViewControllerDelegate>
@property (nonatomic, assign) FeedType feedType;
@end
