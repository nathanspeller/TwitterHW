//
//  TweetDetailViewController.m
//  TwitterHW
//
//  Created by Nathan Speller on 3/29/14.
//  Copyright (c) 2014 Nathan Speller. All rights reserved.
//

#import "TweetDetailViewController.h"
#import "UIImageView+AFNetworking.h"
#import "UIImage+Masking.h"

@interface TweetDetailViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *userImage;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *username;
@property (weak, nonatomic) IBOutlet UILabel *content;
@property (weak, nonatomic) IBOutlet UILabel *timestamp;
@property (weak, nonatomic) IBOutlet UILabel *retweetCount;
@property (weak, nonatomic) IBOutlet UILabel *favoriteCount;

@property (weak, nonatomic) IBOutlet UIButton *retweetButton;
@property (weak, nonatomic) IBOutlet UIButton *favoriteButton;
@property (weak, nonatomic) IBOutlet UIButton *replyButton;

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
    [self setupView];
    [self updateButtons];
    [self refresh];
}

- (void)setupView{
    // Move content from under the navigation bar
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
    
    // buttons
    [self.retweetButton addTarget:self action:@selector(onRetweet:) forControlEvents:UIControlEventTouchUpInside];
    [self.favoriteButton addTarget:self action:@selector(onFavorite:) forControlEvents:UIControlEventTouchUpInside];
    [self.replyButton addTarget:self action:@selector(onReply:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)updateButtons{
    UIImage *retweetImage  = [[UIImage imageNamed:@"repeat"]
                              maskWithColor:[UIColor darkGrayColor]];
    UIImage *favoriteImage = [[UIImage imageNamed:@"star"]
                              maskWithColor:[UIColor darkGrayColor]];
    UIImage *replyImage    = [[UIImage imageNamed:@"reply"]
                              maskWithColor:[UIColor darkGrayColor]];
    
    [self.retweetButton  setBackgroundImage:retweetImage  forState:UIControlStateNormal];
    [self.favoriteButton setBackgroundImage:favoriteImage forState:UIControlStateNormal];
    [self.replyButton    setBackgroundImage:replyImage    forState:UIControlStateNormal];
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

- (void)onRetweet:(id)sender{
    NSLog(@"RETWEET TWEET");
}

- (void)onFavorite:(id)sender{
    NSLog(@"FAVORITTEE");
}

- (void)onReply:(id)sender{
    NSLog(@"REPLYYY");
}

@end
