//
//  RestaurantManager.h
//  FOS_Dong_Rong_Tran
//
//  Created by YIFU RONG on 1/6/17.
//  Copyright © 2017 rjtcompuquest. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Restaurant.h"
#import "Constant.h"

@interface RestaurantManager : NSObject

@property (retain, nonatomic) NSMutableArray <Restaurant*> *allRestaurant;
@property (retain, nonatomic) Restaurant* currentRestaurant;
+ (instancetype) sharedInstance;
- (void) nearByRestaurantsByLatitude:(NSString *)latitude longitude:(NSString *)longitude radius:(NSString*) radius query:(NSString *) query completionHandler:(void (^)(NSMutableArray* dataArray))completionBlock;
@end
