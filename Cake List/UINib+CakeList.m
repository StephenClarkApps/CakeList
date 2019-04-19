//
//  UINib+CakeList.m
//  Cake List
//
//  Created by Stephen Clark on 19/04/2019.
//

#import "UINib+CakeList.h"

@implementation NSObject (NIB)

+ (UINib *)nibForClass {
    return [UINib nibWithNibName:[self normalizedNibName] bundle:nil];
}

+ (NSString *)nibIdentifier {
    return [self normalizedNibName];
}

+ (instancetype)loadFromNib {
    NSArray *nibObjects = [[NSBundle mainBundle] loadNibNamed:[self normalizedNibName]
                                                        owner:nil
                                                      options:nil];
    for (id nibView in nibObjects) {
        if ([nibView isKindOfClass:[self class]]) {
            return nibView;
        }
    }
    return nil;
}

/*!
 Objective-C and Swift classes are named differently, so we may need to work out the name of the file to look up.
 Specifically: Swift class names work like: TARGET.CLASS BUT Objective C class names are just CLASS
 
 @return the name of the class without any potential prefixes (by taking just the bit after `.` where relevant)
 */
+ (NSString *)normalizedNibName {
    NSString *fullClassName = NSStringFromClass([self class]);
    return [fullClassName componentsSeparatedByString:@"."].lastObject;
}

@end
