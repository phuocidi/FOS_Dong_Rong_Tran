//
//  Restaurant.h
//  FOS_Dong_Rong_Tran
//
//  Created by YIFU RONG on 1/6/17.
//  Copyright © 2017 rjtcompuquest. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Restaurant : NSObject

@property(copy, nonatomic) NSString *latitude;
@property(copy, nonatomic) NSString *longitude;
@property(copy, nonatomic) NSString *name;
@property(copy, nonatomic) NSString *address;
@property(copy, nonatomic) NSString *distance;

@end
