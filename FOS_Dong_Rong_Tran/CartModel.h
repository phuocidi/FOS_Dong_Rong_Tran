//
//  CartModel.h
//  Test
//
//  Created by YIFU RONG on 12/31/16.
//  Copyright © 2016 Yifu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Cart.h"

@interface CartModel : NSObject

/*
    Creat new Cart object and put into tbl_Cart
    Need modify the query, it is hard code
 */
-(BOOL)createUser: (int)user_phone name: (NSString *)food_name category: (NSString *)food_category add: (NSString *)food_add number: (int)numberOfNeed date: ( NSString* )food_date price: (double)food_price;

/*
    Get All Cart object, each object is a Dictionary
    ** And the type of each parameter is samve with Cart Model
 
    Example:
    "food_id" = 707;
    "food_name" = "Chicken tikka meatballs";
    "food_price" = 1550;
    "food_recepiee" = "chicken tikka meatballs, chopped tomato makh";
    "food_thumb" = "Image URL";
    numberOfNeed = 1;
 */
-(NSMutableArray *)allUsers;

/*
    Update Cart object
    Need to modify the query, find which parameter you want to change
 */
-(BOOL)saveUser: (Cart *)user;

@end

















