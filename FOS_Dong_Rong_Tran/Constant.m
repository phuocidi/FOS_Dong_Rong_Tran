//
//  Constant.m
//  FOS_Dong_Rong_Tran
//
//  Created by Huu Tran on 12/30/16.
//  Copyright © 2016 rjtcompuquest. All rights reserved.
//

#import "Constant.h"

static NSString * const foodKeyCategoryVeg = @"veg";
static NSString * const foodKeyCategoryNonVeg = @"non-veg";
static NSString * const foodKeyID = @"FoodId";
static NSString * const foodKeyName = @"FoodName";
static NSString * const foodKeyPrice = @"FoodPrice";
static NSString * const foodKeyRecepiee = @"FoodRecepiee";
static NSString * const foodKeyImgURL = @"FoodThumb";
static NSString * const foodKey = @"Food";

@implementation Constant
+ (NSString *)  foodKey { return foodKey; }
+ (NSString*) foodKeyID { return foodKeyID; }
+ (NSString*) foodKeyName {return foodKeyName; }
+ (NSString*) foodKeyPrice {return foodKeyPrice; }
+ (NSString*) foodKeyRecepiee {return foodKeyRecepiee; }
+ (NSString*) foodKeyImgURL {return foodKeyImgURL;}
+ (NSString *) foodKeyCategoryVeg { return foodKeyCategoryVeg; }
+ (NSString *)  foodKeyCategoryNonVeg { return foodKeyCategoryNonVeg; }



@end
