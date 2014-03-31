//
//  TimelineViewController.m
//  TwitterHW
//
//  Created by Nathan Speller on 3/28/14.
//  Copyright (c) 2014 Nathan Speller. All rights reserved.
//

#import "TimelineViewController.h"
#import "TweetDetailViewController.h"
#import "ComposeTweetViewController.h"
#import "TwitterClient.h"
#import "TweetCell.h"
#import "Tweet.h"
#import "User.h"

@interface TimelineViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *tweets;
@property (nonatomic, strong) TweetCell *prototype;
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
    
    [self setupNavigationBar];
    
    self.tweets = [[NSMutableArray alloc] init];
    UINib *tweetCellNib = [UINib nibWithNibName:@"TweetCell" bundle:nil];
    self.prototype = [tweetCellNib instantiateWithOwner:self options:nil][0];
    [self.tableView registerNib:tweetCellNib forCellReuseIdentifier:@"TweetCell"];
    
    [self fetchData];
}

- (void)setupNavigationBar{
    // pull-to-refresh
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:refreshControl];
    
    UIBarButtonItem *composeTweetButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"composing.png"] style:UIBarButtonItemStylePlain target:self action:@selector(onComposeTweetButton:)];
    self.navigationItem.rightBarButtonItem = composeTweetButton;
    
    UIBarButtonItem *logoutButton = [[UIBarButtonItem alloc] initWithTitle:@"Logout" style:UIBarButtonItemStylePlain target:self action:@selector(onLogoutButton:)];
    self.navigationItem.leftBarButtonItem = logoutButton;
    
    // twitter logo
    UIImage *twitterImage = [UIImage imageNamed:@"twitter_bird.png"];
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:twitterImage];
    
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:0.184 green:0.761 blue:0.937 alpha:1.000];
}

- (void)fetchData{
    [[TwitterClient instance] homeTimeLineWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"hometimelinesseccess %@", responseObject);
        [self.tweets removeAllObjects];
        for(NSDictionary *tweetDict in responseObject){
            Tweet *tweet = [[Tweet alloc] initWithDictionary:tweetDict];
            [self.tweets addObject:tweet];
        }
        [self.tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"fail whale");
    }];
}

- (void)refresh:(UIRefreshControl *)refreshControl {
    [self fetchData];
    [refreshControl endRefreshing];
}


- (void)onComposeTweetButton:(id)sender{
    ComposeTweetViewController *composeVC = [[ComposeTweetViewController alloc] init];
    [self.navigationController pushViewController:composeVC animated:YES];
}

- (void)onLogoutButton:(id)sender{
    [User logoutUser];
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
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    TweetDetailViewController *vc = [[TweetDetailViewController alloc] init];
    vc.tweet = [self.tweets objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [TweetCell heightForTweet:[self.tweets objectAtIndex:indexPath.row] cell:self.prototype];
}

@end
