//
//  HamburgerViewController.m
//  TwitterHW
//
//  Created by Nathan Speller on 4/4/14.
//  Copyright (c) 2014 Nathan Speller. All rights reserved.
//

#import "HamburgerViewController.h"
#import "TimelineViewController.h"
#import "ProfileViewController.h"

@interface HamburgerViewController ()
@property (nonatomic, strong) UINavigationController *navigationController;
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
        TimelineViewController *timelineVC = [[TimelineViewController alloc] init];
        ProfileViewController  *profileVC = [[ProfileViewController alloc] init];
        
        self.navigationController = [[UINavigationController alloc] initWithRootViewController:timelineVC];
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
    
    //register observer for hamburger button
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(toggleMenu) name:@"toggleMenu" object:nil];
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
}

- (IBAction)onTimeline:(id)sender {
}

- (IBAction)onMentions:(id)sender {
}

- (IBAction)onLogout:(id)sender {
}
@end
