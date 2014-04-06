//
//  ProfileHeaderCell.m
//  TwitterHW
//
//  Created by Nathan Speller on 4/5/14.
//  Copyright (c) 2014 Nathan Speller. All rights reserved.
//

#import "ProfileHeaderCell.h"
#import "UIImageView+AFNetworking.h"

@implementation ProfileHeaderCell

- (void)setUser:(User *)user{
    _user = user;
    self.name.text = self.user.name;
    self.username.text = [NSString stringWithFormat:@"@%@", self.user.screenName];
    [self.profileImage setImageWithURL:[NSURL URLWithString:self.user.profileImageURL]];
    self.profileImage.layer.masksToBounds = YES;
    self.profileImage.layer.cornerRadius = 2.0f;
    self.profileBorder.layer.masksToBounds = YES;
    self.profileBorder.layer.cornerRadius = 6.0f;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
