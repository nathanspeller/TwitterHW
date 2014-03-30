//
//  TweetCell.m
//  TwitterHW
//
//  Created by Nathan Speller on 3/28/14.
//  Copyright (c) 2014 Nathan Speller. All rights reserved.
//

#import "TweetCell.h"
#import "UIImageView+AFNetworking.h"
#import "Tweet.h"

@implementation TweetCell

+ (CGFloat)heightForTweet:(Tweet *)tweet cell:(TweetCell *)prototype{

    CGFloat nameWidth = prototype.content.frame.size.width;
    UIFont *font = prototype.content.font;
    CGSize constrainedSize = CGSizeMake(nameWidth, 9999);
    NSDictionary *attributesDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                          font, NSFontAttributeName, nil];
    
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:tweet.content attributes:attributesDictionary];
    
    CGRect requiredHeight = [string boundingRectWithSize:constrainedSize options:NSStringDrawingUsesLineFragmentOrigin context:nil];
    
    return 47+requiredHeight.size.height;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setTweet:(Tweet *)tweet{
    _tweet = tweet;
    self.name.text = self.tweet.name;
    self.username.text = [NSString stringWithFormat:@"@%@", self.tweet.username];
    self.content.text = self.tweet.content;
    [self.userImage setImageWithURL:self.tweet.userImage];
    self.userImage.layer.masksToBounds = YES;
    self.userImage.layer.cornerRadius = 3.0f;
    
    
    int secondsAgo = (int) [[NSDate date] timeIntervalSinceDate:self.tweet.timestamp];
    if (secondsAgo < 60){ //seconds
        self.timestamp.text = [NSString stringWithFormat:@"%ds", secondsAgo];
    } else if (secondsAgo < (60*60)){ //minutes
        self.timestamp.text = [NSString stringWithFormat:@"%dm", secondsAgo/60];
    } else if(secondsAgo < (60*60*24)) { // hours
        self.timestamp.text = [NSString stringWithFormat:@"%dh", secondsAgo/(60*60)];
    } else { // days
        self.timestamp.text = [NSString stringWithFormat:@"%dd", secondsAgo/(60*60*24)];
    }
}

@end
