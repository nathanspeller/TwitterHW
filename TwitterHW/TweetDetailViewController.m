//
//  TweetDetailViewController.m
//  TwitterHW
//
//  Created by Nathan Speller on 3/29/14.
//  Copyright (c) 2014 Nathan Speller. All rights reserved.
//

#import "TweetDetailViewController.h"
#import "UIImageView+AFNetworking.h"

@interface TweetDetailViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *userImage;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *username;
@property (weak, nonatomic) IBOutlet UILabel *content;
@property (weak, nonatomic) IBOutlet UILabel *timestamp;
@property (weak, nonatomic) IBOutlet UIImageView *favorite;
@property (weak, nonatomic) IBOutlet UIImageView *retweet;
@property (weak, nonatomic) IBOutlet UIImageView *reply;
@property (weak, nonatomic) IBOutlet UILabel *retweetCount;
@property (weak, nonatomic) IBOutlet UILabel *favoriteCount;
@end

@implementation TweetDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupStyles];
    [self refresh];
}

- (void)setupStyles{
    // Move content from under the navigation bar
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
    self.favorite.image = [UIImage imageNamed:@"star"];
    self.retweet.image  = [UIImage imageNamed:@"repeat"];
    self.reply.image    = [UIImage imageNamed:@"reply"];
}

- (void)refresh{
    self.name.text = self.tweet.name;
    self.username.text = [NSString stringWithFormat:@"@%@", self.tweet.username];
    self.content.text = self.tweet.content;
    [self.userImage setImageWithURL:self.tweet.userImage];
    self.userImage.layer.masksToBounds = YES;
    self.userImage.layer.cornerRadius = 3.0f;
    self.retweetCount.text = [NSString stringWithFormat:@"%lu", (unsigned long)self.tweet.retweetCount];
    self.favoriteCount.text = [NSString stringWithFormat:@"%lu", (unsigned long)self.tweet.favoriteCount];
    
    
    self.timestamp.text = [NSDateFormatter localizedStringFromDate:self.tweet.timestamp
                                   dateStyle:NSDateFormatterShortStyle
                                   timeStyle:NSDateFormatterShortStyle];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
