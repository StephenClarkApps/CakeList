//
//  CLNetworking.h
//  Cake List
//
//  Created by Stephen Clark on 19/04/2019.
//
#import "CLCake.h"

@interface CLNetworking : NSObject

@property (nonatomic, strong) NSURLSessionDataTask *sessionTask;
@property (nonatomic, copy) void (^completionHandler)(NSError *, NSData *);

- (void)getDataFromURL:(NSString *)urlString;
- (void)getCakesListData:(NSString *)cakeUrl
        withSuccessBlock:(void (^)(NSArray *objects))success
         andFailureBlock:(void (^)(NSError *error))failure;

@end

