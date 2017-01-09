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

static NSString* const orderKeyName = @"order_name";
static NSString* const orderKeyMobile = @"user_phone";
static NSString* const orderKeyQuantity = @"order_quantity";
static NSString* const orderKeyTotal = @"total_order";
static NSString* const orderKeyAddress = @"order_delivery_add";
static NSString* const orderKeyDate = @"order_date";
static NSString* const orderKeyCategory = @"order_category";

static NSString* const orderRecentKeyMobile =  @"user_phone";
static NSString* const orderRecentKey =  @"Order Detail";
static NSString* const orderRecentKeyID =  @"OrderId";
static NSString* const orderRecentKeyName =  @"OrderName";
static NSString* const orderRecentKeyQuantity =  @"OrderQuantity";
static NSString* const orderRecentKeyTotal =  @"TotalOrder";
static NSString* const orderRecentKeyStatus =  @"OrderStatus";
static NSString* const orderRecentKeyAddress =  @"OrderDeliverAdd";
static NSString* const orderRecentKeyDate =  @"OrderDate";


static NSString* const orderStatusKeyID =  @"order_id";
static NSString* const orderStatusKey =  @"Order Detail";

static NSString* const fourSquareCategoryId = @"4d4b7105d754a06374d81259";
static NSString* const fourSquareCategoryKey =  @"categoryId";
static NSString* const fourSquareOauthKey = @"oauth_token";
static NSString* const fourSquareOAuthToken = @"FNN31VDGWRFGXXWGLXODLHEOLJGO2WEJ3EP0GQSG0RSH1U3D";
static NSString* const fourSquareVersionAPI = @"20170108";
static NSString* const fourSquareVersionKey = @"v";



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


+ (NSString*) orderRecentKey {return orderRecentKey;}
+ (NSString*) orderRecentKeyID {return orderRecentKeyID;}
+ (NSString*) orderRecentKeyName {return orderRecentKeyName;}
+ (NSString*) orderRecentKeyQuantity{return orderRecentKeyQuantity;}
+ (NSString*) orderRecentKeyTotal {return orderRecentKeyTotal;}
+ (NSString*) orderRecentKeyStatus {return orderRecentKeyStatus;}
+ (NSString*) orderRecentKeyAddress {return orderRecentKeyAddress;}
+ (NSString*) orderRecentKeyDate {return orderRecentKeyDate;}
+ (NSString*) orderRecentKeyMobile {return orderRecentKeyMobile;}

+ (NSString*) orderStatusKeyID {return orderStatusKeyID;}
+ (NSString*) orderStatusKey {return orderStatusKey;}

+ (NSString*) fourSquareOauthParam {return fourSquareOauthKey;}
+ (NSString*) fourSquareTokenStr {return fourSquareOauthKey;}
+ (NSString*) fourSquareVersionStr {return fourSquareVersionAPI;}
+ (NSString*) fourSquareVersionParam {return fourSquareVersionKey;}
+ (NSString*) fourSquareCategoryParam{return fourSquareCategoryKey;}
+ (NSString*) fourSquareCategoryIdStr{return fourSquareCategoryId;}
@end
