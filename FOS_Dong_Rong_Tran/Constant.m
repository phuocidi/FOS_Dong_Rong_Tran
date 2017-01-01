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


//&order_category=veg&order_name=Biryani&order_quantity=2&total_order=700&order_delivery_add=noida&order_date=2016-12-21 11:32:56&user_phone=55565454

static NSString* const orderKeyName = @"order_name";
static NSString* const orderKeyMobile = @"user_phone";
static NSString* const orderKeyQuantity = @"order_quantity";
static NSString* const orderKeyTotal = @"total_order";
static NSString* const orderKeyAddress = @"order_delivery_add";
static NSString* const orderKeyDate = @"order_date";
static NSString* const orderKeyCategory = @"order_category";

@implementation Constant
+ (NSString *)  foodKey { return foodKey; }
+ (NSString*) foodKeyID { return foodKeyID; }
+ (NSString*) foodKeyName {return foodKeyName; }
+ (NSString*) foodKeyPrice {return foodKeyPrice; }
+ (NSString*) foodKeyRecepiee {return foodKeyRecepiee; }
+ (NSString*) foodKeyImgURL {return foodKeyImgURL;}
+ (NSString *) foodKeyCategoryVeg { return foodKeyCategoryVeg; }
+ (NSString *)  foodKeyCategoryNonVeg { return foodKeyCategoryNonVeg; }

+ (NSString*) orderKeyName { return orderKeyName; }
+ (NSString*) orderKeyMobile {return orderKeyMobile; }
+ (NSString*) orderKeyQuantity {return orderKeyQuantity;}
+ (NSString*) orderKeyTotal { return orderKeyTotal;}
+ (NSString*) orderKeyAddress { return orderKeyAddress;}
+ (NSString*) orderKeyDate {return orderKeyDate;}
+ (NSString*) orderKeyCategory {return orderKeyCategory;}


@end
