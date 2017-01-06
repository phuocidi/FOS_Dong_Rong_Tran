//
//  Restaurant.h
//  FOS_Dong_Rong_Tran
//
//  Created by YIFU RONG on 1/6/17.
//  Copyright © 2017 rjtcompuquest. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Restaurant : NSObject

@property(strong, nonatomic) NSString *latitude;
@property(strong, nonatomic) NSString *longitude;
@property(strong, nonatomic) NSString *name;

+ (NSArray *)getAllRestaurant;

@end
