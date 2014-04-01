//
//  TimelineViewController.h
//  TwitterHW
//
//  Created by Nathan Speller on 3/28/14.
//  Copyright (c) 2014 Nathan Speller. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ComposeTweetViewController.h"

@interface TimelineViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, ComposeTweetViewControllerDelegate>

@end
