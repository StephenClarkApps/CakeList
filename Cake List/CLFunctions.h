//
//  CLFunctions.h
//  Cake List
//
//  Created by Stephen Clark on 19/04/2019.
//  Copyright © 2019 Stewart Hart. All rights reserved.
//

#ifndef CLFunctions_h
#define CLFunctions_h

@interface CLFunctions : NSObject
/**
 Run a block on the main thread without deadlocking.
 */
void runOnMainQueueWithoutDeadlocking(void (^block)(void));

@end
#endif /* CLFunctions_h */
