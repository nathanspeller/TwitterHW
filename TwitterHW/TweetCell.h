//
//  TweetCell.h
//  TwitterHW
//
//  Created by Nathan Speller on 3/28/14.
//  Copyright (c) 2014 Nathan Speller. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"

@interface TweetCell : UITableViewCell
@property (nonatomic, strong) Tweet *tweet;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *username;
@property (weak, nonatomic) IBOutlet UILabel *content;
@property (weak, nonatomic) IBOutlet UIImageView *userImage;
@property (weak, nonatomic) IBOutlet UILabel *timestamp;

+ (CGFloat)heightForTweet:(Tweet *)tweet cell:(TweetCell *)prototype;
- (void)setTweet:(Tweet *)tweet;
@end
