//
//  UserModel.h
//  Test
//
//  Created by YIFU RONG on 12/31/16.
//  Copyright © 2016 Yifu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@interface UserModel : NSObject

/*
    Creat new User object and put into tbl_User
    Need modify the query, it is hard code
 */
-(BOOL)createUser: (int)user_phone name: (NSString *)user_name email: (NSString *)user_email password: (NSString *)user_password add: ( NSString* )user_add longtitude: (double)user_longitude latitude: (double)user_latitude;

/*
    Get All User object, each object is a Dictionary
    ** And the type of each parameter is samve with User Model
 
    Example:
    "user_add" = Michigen;
    "user_email" = "yifu@gamil.com";
    "user_latitude" = "41.5359";
    "user_longitude" = "-88.2024";
    "user_name" = "Yifu Rong";
    "user_password" = 123;
    "user_phone" = 1;
 */
-(NSMutableArray *)allUsers;

/*
    Update User object
    Need to modify the query, find which parameter you want to change
 */
-(BOOL)saveUser: (User *)user;

@end
