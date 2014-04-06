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
