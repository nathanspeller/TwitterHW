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
#import "TwitterClient.h"
#import "Tweet.h"
#import "ComposeTweetViewController.h"

@interface TweetDetailViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *userImage;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *username;
@property (weak, nonatomic) IBOutlet UILabel *content;
@property (weak, nonatomic) IBOutlet UILabel *timestamp;
@property (weak, nonatomic) IBOutlet UILabel *retweetCount;
@property (weak, nonatomic) IBOutlet UILabel *favoriteCount;

@property (weak, nonatomic) IBOutlet UIButton *retweetButton;
@property (weak, nonatomic) IBOutlet UIButton *replyButton;
@property (weak, nonatomic) IBOutlet UIButton *favoriteButton;

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
    
    UIBarButtonItem *replyButton = [[UIBarButtonItem alloc] initWithTitle:@"Reply" style:UIBarButtonItemStylePlain target:self action:@selector(onReply:)];
    self.navigationItem.rightBarButtonItem = replyButton;
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
    [self updateButtons];
}

- (void)updateButtons{
    UIColor *retweetColor = self.tweet.retweeted ? [UIColor colorWithRed:0.431 green:0.604 blue:0.180 alpha:1.000] : [UIColor lightGrayColor];
    UIColor *favoriteColor = self.tweet.favorited ? [UIColor colorWithRed:1.000 green:0.608 blue:0.000 alpha:1.000] : [UIColor lightGrayColor];
    UIImage *retweetImage  = [[UIImage imageNamed:@"repeat"]
                              maskWithColor:retweetColor];
    UIImage *favoriteImage = [[UIImage imageNamed:@"star"]
                              maskWithColor:favoriteColor];
    UIImage *replyImage    = [[UIImage imageNamed:@"reply"]
                              maskWithColor:[UIColor lightGrayColor]];
    
    [self.retweetButton  setImage:retweetImage  forState:UIControlStateNormal];
    [self.favoriteButton setImage:favoriteImage forState:UIControlStateNormal];
    [self.replyButton    setImage:replyImage    forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)onRetweet:(id)sender{
    if (!self.tweet.retweeted) {
        [[TwitterClient instance] retweetTweet:self.tweet.tweetId success:^(AFHTTPRequestOperation *operation, id responseObject) {
            Tweet *responseTweet = [[Tweet alloc] initWithDictionary:responseObject];
            self.tweet = responseTweet;
            [self refresh];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Failed to retweet with ID %@", self.tweet.tweetId);
        }];
    }
}

- (void)onFavorite:(id)sender{
    if (self.tweet.favorited) {
        [[TwitterClient instance] unfavoriteTweet:self.tweet.tweetId success:^(AFHTTPRequestOperation *operation, id responseObject) {
            Tweet *responseTweet = [[Tweet alloc] initWithDictionary:responseObject];
            self.tweet = responseTweet;
            [self refresh];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Failed to unfavorite tweet with ID %@", self.tweet.tweetId);
        }];
    } else {
        [[TwitterClient instance] favoriteTweet:self.tweet.tweetId success:^(AFHTTPRequestOperation *operation, id responseObject) {
            Tweet *responseTweet = [[Tweet alloc] initWithDictionary:responseObject];
            self.tweet = responseTweet;
            [self refresh];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Failed to favorite tweet with ID %@", self.tweet.tweetId);
        }];
    }
}

- (void)onReply:(id)sender{
    ComposeTweetViewController *replyVC = [[ComposeTweetViewController alloc] init];
    replyVC.pretweetContent = [NSString stringWithFormat:@"@%@ ", self.tweet.username];
    replyVC.inReplyToStatusId = self.tweet.tweetId;
    [self.navigationController pushViewController:replyVC animated:YES];
}

@end
