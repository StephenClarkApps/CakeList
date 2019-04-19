//
//  CLCake.h
//  Cake List
//
//  Created by Stephen Clark on 19/04/2019.
//  Copyright © 2019 Stewart Hart. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CLCake;

NS_ASSUME_NONNULL_BEGIN

typedef NSMutableArray<CLCake *> CLCakes;

#pragma mark - Object interfaces

@interface CLCake : NSObject
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *descript;
@property (nonatomic, copy) NSString *image;
@end

NS_ASSUME_NONNULL_END
