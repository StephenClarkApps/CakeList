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
    self.separatorInset = UIEdgeInsetsMake(0, 0, 0, self.bounds.size.width);
}

- (void)prepareForReuse {
    [super prepareForReuse];
    self.cakeImageView.image = [UIImage imageNamed:@"placeholder"];
    self.titleLabel.text = @"";
    self.descriptionLabel.text = @"";
}

@end
