//
//  CakeTableViewCell.m
//  Cake List
//
//  Created by Stephen Clark on 19/04/2019.
//  Copyright © 2019 Stewart Hart. All rights reserved.
//

#import "CakeTableViewCell.h"

@implementation CakeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)prepareForReuse {
    [super prepareForReuse];
    self.cakeImageView.image = [UIImage imageNamed:@"placeholder"] ;
    self.titleLabel.text = @"";
    self.descriptionLabel.text = @"";
}

@end
