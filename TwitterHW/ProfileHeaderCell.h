//
//  ProfileHeaderCell.h
//  TwitterHW
//
//  Created by Nathan Speller on 4/5/14.
//  Copyright (c) 2014 Nathan Speller. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

@interface ProfileHeaderCell : UITableViewCell
@property (nonatomic, strong) User *user;
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *username;
@property (weak, nonatomic) IBOutlet UIView *profileBorder;

- (void)setUser:(User*)user;

@end
