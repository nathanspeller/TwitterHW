//
//  ComposeTweetViewController.m
//  TwitterHW
//
//  Created by Nathan Speller on 3/29/14.
//  Copyright (c) 2014 Nathan Speller. All rights reserved.
//

#import "ComposeTweetViewController.h"
#import "TwitterClient.h"

@interface ComposeTweetViewController ()
@property (weak, nonatomic) IBOutlet UITextView *tweetTextView;
@property (weak, nonatomic) IBOutlet UILabel *charactersLeft;

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
    self.tweetTextView.delegate = self;
    [self.tweetTextView becomeFirstResponder];
}

- (void)onTweetButton:(id)sender{
    [[TwitterClient instance] tweetStatus:self.tweetTextView.text success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Success");
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Fail");
    }];
}

-(BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    [self updateTweetability];
    NSLog(@"ShouldBeginEditing");
    return YES;
}

-(void)textViewDidBeginEditing:(UITextView *)textView {
    NSLog(@"DidBeginEditing");
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView{
    NSLog(@"ShouldEndEditing:");
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    NSLog(@"DidEndEditing: %@",textView.text);
}

- (void)textViewDidChange:(UITextView *)textView{
    NSLog(@"textViewDidChange:");
    [self updateTweetability];
}

- (void)updateTweetability{
    NSInteger tweetLength = [self.tweetTextView.text length];
    self.navigationItem.rightBarButtonItem.enabled = (140 >= tweetLength && tweetLength > 0);
    self.charactersLeft.text = [NSString stringWithFormat:@"%i characters left", (140 -tweetLength)];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
