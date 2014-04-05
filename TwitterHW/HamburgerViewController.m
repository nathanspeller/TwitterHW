//
//  HamburgerViewController.m
//  TwitterHW
//
//  Created by Nathan Speller on 4/4/14.
//  Copyright (c) 2014 Nathan Speller. All rights reserved.
//

#import "HamburgerViewController.h"
#import "TimelineViewController.h"

@interface HamburgerViewController ()
@property (nonatomic, strong) UINavigationController *navigationController;
@property (nonatomic, assign) CGPoint viewLocation;
@end

@implementation HamburgerViewController

static float openMenuPosition = 280; //open menu position

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        TimelineViewController *timelineVC = [[TimelineViewController alloc] init];
        self.navigationController = [[UINavigationController alloc] initWithRootViewController:timelineVC];
        self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:0.184 green:0.761 blue:0.937 alpha:1.000];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.contentView addSubview:self.navigationController.view];
    
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(onCustomPan:)];
    [self.contentView addGestureRecognizer:panGestureRecognizer];
    // Do any additional setup after loading the view from its nib.
}

- (void)onCustomPan:(UIPanGestureRecognizer *)panGestureRecognizer{
    CGPoint point    = [panGestureRecognizer locationInView:self.view];
    CGPoint velocity = [panGestureRecognizer velocityInView:self.view];
    
    if (panGestureRecognizer.state == UIGestureRecognizerStateBegan) {
        self.viewLocation = CGPointMake(point.x - self.contentView.frame.origin.x, point.y - self.contentView.frame.origin.y);
    } else if (panGestureRecognizer.state == UIGestureRecognizerStateChanged) {
        float xPos = (point.x - self.viewLocation.x);
        if (xPos < 0) {
            xPos = 0;
        }
        if (xPos > openMenuPosition) {
            xPos = openMenuPosition;
        }
        self.contentView.frame = CGRectMake( xPos, 0, self.contentView.frame.size.width, self.contentView.frame.size.height);
    } else if (panGestureRecognizer.state == UIGestureRecognizerStateEnded) {
        if (velocity.x > 0) {
            float animationTime = 0.4*(openMenuPosition - self.contentView.frame.origin.x)/openMenuPosition;
            [UIView animateWithDuration:animationTime animations:^{
                self.contentView.frame = CGRectMake( openMenuPosition, 0, self.contentView.frame.size.width, self.contentView.frame.size.height);
            }];
        } else {
            float animationTime = 0.4*(self.contentView.frame.origin.x)/openMenuPosition;
            [UIView animateWithDuration:animationTime animations:^{
                self.contentView.frame = CGRectMake( 0, 0, self.contentView.frame.size.width, self.contentView.frame.size.height);
            }];
        }
        
        self.viewLocation = point;
    }
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
