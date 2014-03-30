//
//  TimelineViewController.m
//  TwitterHW
//
//  Created by Nathan Speller on 3/28/14.
//  Copyright (c) 2014 Nathan Speller. All rights reserved.
//

#import "TimelineViewController.h"
#import "TweetDetailViewController.h"
#import "TwitterClient.h"
#import "TweetCell.h"
#import "Tweet.h"

@interface TimelineViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *tweets;
@end

@implementation TimelineViewController

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
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.tweets = [[NSMutableArray alloc] init];
    UINib *tweetCellNib = [UINib nibWithNibName:@"TweetCell" bundle:nil];
    //    self.prototypeCell = [tweetCellNib instantiateWithOwner:self options:nil][0];
    [self.tableView registerNib:tweetCellNib forCellReuseIdentifier:@"TweetCell"];
    
    [[TwitterClient instance] homeTimeLineWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"hometimelinesseccess %@", responseObject);
        for(NSDictionary *tweetDict in responseObject){
            Tweet *tweet = [[Tweet alloc] initWithDictionary:tweetDict];
            [self.tweets addObject:tweet];
        }
        [self.tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"fail whale");
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.tweets count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    TweetCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TweetCell"];
    Tweet *tweet = [self.tweets objectAtIndex:indexPath.row];
    
//    UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(13, 7, 60, 90)];
//    [img setImageWithURL:movie.thumbnailURL];
//    [cell addSubview:img];
    [cell setTweet:tweet];
    
    return cell;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:NO];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    TweetDetailViewController *vc = [[TweetDetailViewController alloc] init];
    vc.tweet = [self.tweets objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 104.0;
}

@end
