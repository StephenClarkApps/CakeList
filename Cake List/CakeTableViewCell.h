//
//  CakeTableViewCell.h
//  Cake List
//
//  Created by Stephen Clark on 19/04/2019.
//  Copyright © 2019 Stewart Hart. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CakeTableViewCell: UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *cakeImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@end
