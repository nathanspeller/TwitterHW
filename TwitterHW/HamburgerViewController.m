//
//  HamburgerViewController.m
//  TwitterHW
//
//  Created by Nathan Speller on 4/4/14.
//  Copyright (c) 2014 Nathan Speller. All rights reserved.
//

#import "HamburgerViewController.h"
#import "ListViewController.h"
#import "ProfileViewController.h"
#import "UIImageView+AFNetworking.h"

@interface HamburgerViewController ()
@property (nonatomic, strong) UINavigationController *navigationController;
@property (nonatomic, strong) ListViewController *timelineViewController;
@property (nonatomic, strong) ListViewController *mentionsViewController;
@property (nonatomic, strong) ProfileViewController *profileViewController;
@property (nonatomic, assign) CGPoint viewOriginOnPan;
@property (nonatomic, strong) UITapGestureRecognizer *tapGestureRecognizer;

- (IBAction)onProfile:(id)sender;
- (IBAction)onTimeline:(id)sender;
- (IBAction)onMentions:(id)sender;
- (IBAction)onLogout:(id)sender;
@end

@implementation HamburgerViewController

static float openMenuPosition = 265; //open menu x position

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.timelineViewController = [[ListViewController alloc] init];
        self.timelineViewController.feedType = TIMELINE;
        self.profileViewController  = [[ProfileViewController alloc] init];
        [self.profileViewController setUser:[User currentUser]];
        
        self.mentionsViewController = [[ListViewController alloc] init];
        self.mentionsViewController.feedType = MENTIONS;
        
        self.navigationController = [[UINavigationController alloc] initWithRootViewController:self.timelineViewController];
        self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:0.184 green:0.761 blue:0.937 alpha:1.000];
        [self.navigationController.navigationBar setTranslucent:NO];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.contentView addSubview:self.navigationController.view];
    
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(onCustomPan:)];
    [self.contentView addGestureRecognizer:panGestureRecognizer];
    
    [self styleMenu];
    
    //register observer for hamburger button
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(toggleMenu) name:@"toggleMenu" object:nil];
}

- (void)styleMenu{
    User *currentUser = [User currentUser];
    self.name.text = currentUser.name;
    self.username.text = [NSString stringWithFormat:@"@%@", currentUser.screenName];
    [self.userImage setImageWithURL:[NSURL URLWithString:currentUser.profileImageURL]];
    self.userImage.layer.masksToBounds = YES;
    self.userImage.layer.cornerRadius = 3.0f;
}

- (void)toggleMenu{
    // add tap gesture for closing menu
    if (self.tapGestureRecognizer == nil) {
        self.tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toggleMenu)];
        self.tapGestureRecognizer.numberOfTapsRequired = 1;
        [self.contentView addGestureRecognizer:self.tapGestureRecognizer];
    }
    
    float xPos = (self.contentView.frame.origin.x == 0) ? openMenuPosition : 0;
    [UIView animateWithDuration:0.4 animations:^{
        self.contentView.frame = CGRectMake( xPos, 0, self.contentView.frame.size.width, self.contentView.frame.size.height);
    }];
    [self updateMenuOptions];
}

- (void)onCustomPan:(UIPanGestureRecognizer *)panGestureRecognizer{
    CGPoint point    = [panGestureRecognizer locationInView:self.view];
    CGPoint velocity = [panGestureRecognizer velocityInView:self.view];
    
    if (panGestureRecognizer.state == UIGestureRecognizerStateBegan) {
        self.viewOriginOnPan = CGPointMake(point.x - self.contentView.frame.origin.x, point.y - self.contentView.frame.origin.y);
    } else if (panGestureRecognizer.state == UIGestureRecognizerStateChanged) {
        float xPos = (point.x - self.viewOriginOnPan.x);
        if (xPos < 0) {
            xPos = 0;
        }
        if (xPos > openMenuPosition) {
            xPos = openMenuPosition;
        }
        self.contentView.frame = CGRectMake( xPos, 0, self.contentView.frame.size.width, self.contentView.frame.size.height);
    } else if (panGestureRecognizer.state == UIGestureRecognizerStateEnded) {
        float destinationXPos = (velocity.x > 0) ? openMenuPosition : 0;
        [UIView animateWithDuration:0.25 animations:^{
            self.contentView.frame = CGRectMake( destinationXPos, 0, self.contentView.frame.size.width, self.contentView.frame.size.height);
        }];
        [self updateMenuOptions];
    }
}

- (void)updateMenuOptions{
    BOOL isMenuOpen = self.contentView.frame.origin.x == 0;
    [self.contentView.subviews[0] setUserInteractionEnabled:isMenuOpen];
    self.tapGestureRecognizer.enabled = !isMenuOpen;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onProfile:(id)sender {
    self.profileViewController.user = [User currentUser];
    [self.navigationController pushViewController:self.profileViewController animated:YES];
    [self toggleMenu];
}

- (IBAction)onTimeline:(id)sender {
    [self.navigationController setViewControllers:@[self.timelineViewController] animated:YES];
    [self toggleMenu];
}

- (IBAction)onMentions:(id)sender {
    [self.navigationController setViewControllers:@[self.mentionsViewController] animated:YES];
    [self toggleMenu];
}

- (IBAction)onLogout:(id)sender {
    [User logoutUser];
}
@end
