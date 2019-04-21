//
//  CLNetworking.m
//  Cake List
//
//  Created by Stephen Clark on 19/04/2019.
//

#import <Foundation/Foundation.h>
#import "CLNetworking.h"
#import "CLFunctions.h"

@implementation CLNetworking


/**
 Attempt to get data from a given url using NSURLSession

 @param urlString the URL string
 */
- (void)getDataFromURL:(NSString *)urlString {
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString: urlString]
                                             cachePolicy: NSURLRequestReloadIgnoringCacheData
                                         timeoutInterval: 15.00];
    
    _sessionTask = [[NSURLSession sharedSession] dataTaskWithRequest:request
                                                   completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                       if (error != nil) {
                                                           self.completionHandler(error, NULL);
                                                       } else {
                                                           self.completionHandler(NULL, data);
                                                       }
                                                   }];
    
    [self.sessionTask resume];
}


/**
 Function which tries to retrive `Cakes` from json found at a given URL

 @param cakeUrl the url for the cake json
 @param success completion block for success
 @param failure completion block for failure
 */
- (void)getCakesListData:(NSString *)cakeUrl
        withSuccessBlock:(void (^)(NSArray *objects))success
         andFailureBlock:(void (^)(NSError *error))failure {
    
    [self setCompletionHandler:^(NSError *error, NSData *data) {
        if (error != nil) {
            failure(error);
        } else if (data != nil) {
            NSError *jsonError;
            id responseData = [NSJSONSerialization
                               JSONObjectWithData:data
                               options:kNilOptions
                               error:&jsonError];
            if (!jsonError){
                runOnMainQueueWithoutDeadlocking(^{
                    NSArray *objects = responseData;
                    success(objects);
                });
            } else {
                failure(jsonError);
            }
        }
    }];
    [self getDataFromURL:cakeUrl];
    
}
@end
