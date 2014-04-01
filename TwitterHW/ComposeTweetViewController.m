//
//  ComposeTweetViewController.m
//  TwitterHW
//
//  Created by Nathan Speller on 3/29/14.
//  Copyright (c) 2014 Nathan Speller. All rights reserved.
//

#import "ComposeTweetViewController.h"
#import "UIImageView+AFNetworking.h"
#import "TwitterClient.h"
#import "User.h"

@interface ComposeTweetViewController ()
@property (weak, nonatomic) IBOutlet UITextView *tweetTextView;
@property (weak, nonatomic) IBOutlet UIImageView *userImage;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *username;
@end

@implementation ComposeTweetViewController

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
    [self setupNavigationBar];
    [self setupTextView];

    // Do any additional setup after loading the view from its nib.
}

- (void)setupNavigationBar{    
    UIBarButtonItem *tweetButton = [[UIBarButtonItem alloc] initWithTitle:@"Tweet" style:UIBarButtonItemStylePlain target:self action:@selector(onTweetButton:)];
    self.navigationItem.rightBarButtonItem = tweetButton;
    
    self.navigationItem.title = @"Compose";
}

- (void)setupTextView{
    // Move content from under the navigation bar
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.tweetTextView.delegate = self;
    self.tweetTextView.text = self.pretweetContent;
    [self.tweetTextView becomeFirstResponder];
    
    User *user = [User currentUser];
    self.name.text = user.name;
    self.username.text = [NSString stringWithFormat:@"@%@", user.screenName];
    [self.userImage setImageWithURL: [NSURL URLWithString:user.profileImageURL]];
    self.userImage.layer.masksToBounds = YES;
    self.userImage.layer.cornerRadius = 3.0f;
}

- (void)onTweetButton:(id)sender{
    [[TwitterClient instance] tweetStatus:self.tweetTextView.text inReplyToStatusId:self.inReplyToStatusId success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        Tweet *newTweet = [[Tweet alloc] initWithDictionary:responseObject];
        [self.delegate addTweet:newTweet controller:self];
        
        [self.navigationController popToRootViewControllerAnimated:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Fail");
    }];
}

-(BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    [self updateTweetability];
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView{
    [self updateTweetability];
}

//-(void)textViewDidBeginEditing:(UITextView *)textView {
//}
//
//- (BOOL)textViewShouldEndEditing:(UITextView *)textView{
//    return YES;
//}
//
//- (void)textViewDidEndEditing:(UITextView *)textView{
//}

- (void)updateTweetability{
    NSInteger tweetLength = [self.tweetTextView.text length];
    self.navigationItem.rightBarButtonItem.enabled = (140 >= tweetLength && tweetLength > 0);
    if (tweetLength > 0){
        self.navigationItem.title = [NSString stringWithFormat:@"%i", (140-tweetLength)];
    } else {
        self.navigationItem.title = @"Compose";
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
