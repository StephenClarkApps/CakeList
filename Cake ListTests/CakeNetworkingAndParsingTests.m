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
#import "CLConstants.h"
#import "CLCakesHelper.h"

@interface CakeNetworkingAndParsingTests : XCTestCase

@property (copy, nonatomic) NSArray *cakes;

@end

@implementation CakeNetworkingAndParsingTests


-(void)testNetworkingGetDataIsWorking {
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

-(void)testLocalCakesJsonIsValid {
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];

    NSData *data = [NSData dataWithContentsOfFile:[bundle pathForResource:@"cakes" ofType:@"json"]];
    NSAssert(data != nil, @"data should not be nil");
    
    NSError *jsonError;
    id responseData = [NSJSONSerialization
                       JSONObjectWithData:data
                       options:kNilOptions
                       error:&jsonError];
    NSAssert(jsonError == nil, @"the cakes json should be parsable");
    
    NSArray *objects = responseData;
    CLCakesHelper *cakesHelper = [[CLCakesHelper alloc] init];
    CLCakes *someCakes = [[CLCakes alloc] init];
    someCakes = [cakesHelper makeCakesWhilstTheSunShines:objects];
    
    NSString *testA = someCakes[0].descript;
    NSString *test = @"A cheesecake made of lemon";
    
    XCTAssertEqualObjects(test, testA, @"The description strings should match here");
}

-(void)testParsingOfCakesJsonWorksAsExpected {
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    CLNetworking *networking = [[CLNetworking alloc] init];
    
    NSString *testUrl = @"https://gist.githubusercontent.com/hart88/198f29ec5114a3ec3460/raw/8dd19a88f9b8d24c23d9960f3300d0c917a4f07c/cake.json";
    
    [networking getCakesListData:testUrl withSuccessBlock:^(NSArray *objects) {
        CLCakesHelper *cakesHelper = [[CLCakesHelper alloc] init];
        CLCakes *cakes = [cakesHelper makeCakesWhilstTheSunShines:objects];
        XCTAssertNotNil(cakes);
        NSString *testA = cakes[0].descript;
        NSString *test = @"A cheesecake made of lemon";
        
        XCTAssertEqualObjects(test, testA, @"The description string did not match the expected description.");
        
        dispatch_semaphore_signal(semaphore);
    } andFailureBlock:^(NSError *error) {
        XCTFail(@"Unable to get valid data");
        dispatch_semaphore_signal(semaphore);
    }];
    
    while(dispatch_semaphore_wait(semaphore, DISPATCH_TIME_NOW))
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate dateWithTimeIntervalSinceNow:15.0]];
}


@end
