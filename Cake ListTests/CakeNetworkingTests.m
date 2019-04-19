//
//  CakeNetworkingTests.m
//  Cake ListTests
//
//  Created by Stephen Clark on 19/04/2019.
//  Copyright © 2019 Stewart Hart. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "CLNetworking.h"
#import "CLCake.h"

@interface CakeNetworkingTests : XCTestCase

@property (copy, nonatomic) NSArray *cakes;

@end

@implementation CakeNetworkingTests


-(void)testNetworking {
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);

    CLNetworking *net = [[CLNetworking alloc] init];
    [net setCompletionHandler:^(NSError * error, NSData * data) {
        if (error) {
            XCTFail(@"No data");
            dispatch_semaphore_signal(semaphore);
        } else {
            NSLog(@"There is data");
            dispatch_semaphore_signal(semaphore);
        }
    }];
    [net getDataFromURL:@"https://www.google.com/"];
    while(dispatch_semaphore_wait(semaphore, DISPATCH_TIME_NOW))
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate dateWithTimeIntervalSinceNow:15.0]];
}

-(void)testCakesJson {
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];

    NSData *data = [NSData dataWithContentsOfFile:[bundle pathForResource:@"cakes" ofType:@"json"]];
    NSAssert(data != nil, @"data should not be nil");
    NSError *error = nil;
    NSDictionary *testData = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    NSAssert(error == nil, @"the cakes json should be parsable");
 
}


@end
