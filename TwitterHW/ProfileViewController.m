//
//  ProfileViewController.m
//  TwitterHW
//
//  Created by Nathan Speller on 4/5/14.
//  Copyright (c) 2014 Nathan Speller. All rights reserved.
//

#import "ProfileViewController.h"
#import "TweetCell.h"
#import "ProfileHeaderCell.h"
#import "Tweet.h"
#import "TwitterClient.h"
#import "UIImageView+AFNetworking.h"

@interface ProfileViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *tweets;
@property (nonatomic, strong) TweetCell *prototype;
@property (weak, nonatomic) IBOutlet UIImageView *bannerImage;

@end

@implementation ProfileViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.tweets = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    //removes seperators while information is loading
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    UINib *tweetCellNib = [UINib nibWithNibName:@"TweetCell" bundle:nil];
    self.prototype = [tweetCellNib instantiateWithOwner:self options:nil][0];
    [self.tableView registerNib:tweetCellNib forCellReuseIdentifier:@"TweetCell"];
    self.tableView.backgroundColor = [UIColor clearColor];
    
    UINib *headerCellNib = [UINib nibWithNibName:@"ProfileHeaderCell" bundle:nil];
    [self.tableView registerNib:headerCellNib forCellReuseIdentifier:@"ProfileCell"];
    
    [self fetchData];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.navigationItem.title = self.user.name;
    [self.bannerImage setImageWithURL:[NSURL URLWithString:self.user.bannerImageURL]];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)fetchData{
    [[TwitterClient instance] userTimeLine:self.user success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@", responseObject);
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

#pragma mark - Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tweets.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    if (indexPath.row == 0){
        cell = (ProfileHeaderCell *)[tableView dequeueReusableCellWithIdentifier:@"ProfileCell"];
        cell.backgroundColor = [UIColor clearColor];
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:@"TweetCell"];
        Tweet *tweet = [self.tweets objectAtIndex:indexPath.row];
        [(TweetCell *)cell setTweet:tweet];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0){
        return 160;
    } else {
        return [TweetCell heightForTweet:[self.tweets objectAtIndex:indexPath.row] cell:self.prototype];
    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.tableView.contentOffset.y > 0) {
        //move it up at proper size
        self.bannerImage.frame = CGRectMake(0,-self.tableView.contentOffset.y, 320, 160);
    } else {
        //grow
        self.bannerImage.frame = CGRectMake(0,0, 320, 160-self.tableView.contentOffset.y);
    }
}

@end
