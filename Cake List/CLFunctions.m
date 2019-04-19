//
//  CLFunctions.m
//  Cake List
//
//  Created by Stephen Clark on 19/04/2019.
//  Copyright © 2019 Stewart Hart. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CLFunctions.h"

/** Class that provides various useful functions. */
@implementation CLFunctions

void runOnMainQueueWithoutDeadlocking(void (^block)(void))
{
    if ([NSThread isMainThread]) {
        block();
    } else {
        dispatch_sync(dispatch_get_main_queue(), block);
    }
}

@end
