//
//  UINib+CakeList.m
//  Cake List
//
//  Created by Stephen Clark on 19/04/2019.
//

#import "UINib+CakeList.h"

@implementation NSObject (NIB)

+ (UINib *)nibForClass {
    return [UINib nibWithNibName:[self safeNibName] bundle:nil];
}

+ (NSString *)nibIdentifier {
    return [self safeNibName];
}

+ (instancetype)loadFromNib {
    NSArray *nibObjects = [[NSBundle mainBundle] loadNibNamed:[self safeNibName]
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
 Objective-C and Swift classes are named differently, so we may need to work out
 the name of the file to look up.
 Swift class name = TARGET.CLASS
 Objective C class name = CLASS
 
 @return the name of the class without prefixes (split string on `.`)
 */
+ (NSString *)safeNibName {
    NSString *fullClassName = NSStringFromClass([self class]);
    return [fullClassName componentsSeparatedByString:@"."].lastObject;
}

@end
