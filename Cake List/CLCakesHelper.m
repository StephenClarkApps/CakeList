//
//  CLCakesHelper.m
//  Cake List
//
//  Created by Stephen Clark on 21/04/2019.
//  Copyright © 2019 Stewart Hart. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CLCakesHelper.h"
#import "CLCake.h"

@interface CLCakesHelper ()
@end

@implementation CLCakesHelper


/**
 Deseralise CLCakes array from source data

 @param cakeArr is array of dict objects derived from the original json
 @return return a set of CLCake objects
 */
- (CLCakes *)makeCakesWhilstTheSunShines:(NSArray *)cakeArr {
    NSMutableArray *theCakes = [[CLCakes alloc] init];
    // loop through dictionary elements and manually deserealise
    for (NSDictionary *object in cakeArr) {
        CLCake *cake = [[CLCake alloc] init];
        cake.descript = object[@"desc"];
        cake.image = object[@"image"];
        cake.title = [object[@"title"] capitalizedString];
        [theCakes addObject:cake];
    }
    return theCakes;
}

@end
