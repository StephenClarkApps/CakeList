//
//  UINib+CakeList.h
//  Cake List
//
//  Created by Stephen Clark on 19/04/2019.
//

#import <UIKit/UIKit.h>

@interface NSObject (NIB)

+ (nullable UINib *)nibForClass;
+ (nonnull NSString *)nibIdentifier;
+ (nullable instancetype)loadFromNib;

@end
