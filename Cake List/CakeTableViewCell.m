//
//  CakeTableViewCell.m
//  Cake List
//
//  Created by Stephen Clark on 19/04/2019.
//  Copyright © 2019 Stewart Hart. All rights reserved.
//

#import "CakeTableViewCell.h"
#import <UIKit/UIKit.h>

@implementation CakeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Use this code to allow for a custom separator
    self.separatorInset = UIEdgeInsetsMake(0, 0, 0, self.bounds.size.width);
    [self setupActivityIndicator];
}

/**
 Programatically setup activity indiactor when creating a reusable cell
 */
-(void)setupActivityIndicator {
    self.spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.spinner.frame = CGRectMake(0, 0, self.cakeImageView.frame.size.width, self.cakeImageView.frame.size.height);
    [self.contentView setCenter: self.cakeImageView.center];
    [self.cakeImageView addSubview: self.spinner];
    [self.spinner setHidesWhenStopped: YES];
    [self.spinner startAnimating];
}

- (void)prepareForReuse {
    [super prepareForReuse];
    self.cakeImageView.alpha = 1.0;
    self.cakeImageView.image = [UIImage imageNamed:@"placeholder"];
    self.titleLabel.text = @"";
    self.descriptionLabel.text = @"";
}

@end
