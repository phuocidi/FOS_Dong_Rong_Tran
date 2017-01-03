//
//  CartModel.m
//  Test
//
//  Created by YIFU RONG on 12/31/16.
//  Copyright © 2016 Yifu. All rights reserved.
//

#import "CartModel.h"
#import "SQLiteModel.h"

@interface CartModel()

@property (strong, nonatomic) SQLiteModel *sql;

@end

@implementation CartModel

-(BOOL)createUser: (int)user_phone name: (NSString *)food_name category: (NSString *)food_category add: (NSString *)food_add number: (int)numberOfNeed date: ( NSString* )food_date price: (double)food_price {
    
    self.sql = [SQLiteModel sharedInstance];
    
    NSString* userQuery = @"INSERT INTO tbl_Cart VALUES( NULL, 123, 'veg', 'Chicken tikka meatballs', 'Chicago', 1, 1550, 'date');INSERT INTO tbl_Cart VALUES( NULL, 123, 'veg', 'Chettinad chicken keema', 'Aruora', 1, 1650, 'date');";
    char* errMessage = NULL;
    errMessage = [self.sql excute:userQuery andError:errMessage];
    if( errMessage != NULL ) {
        return FALSE;
    }
    
    return TRUE;
}

- (NSMutableArray *)allUsers {
    self.sql = [SQLiteModel sharedInstance];
    NSMutableArray* array = [ NSMutableArray array ];
    NSString* fetchQuery = [ NSString stringWithFormat : @"SELECT * FROM tbl_Cart;" ];
    
    // instanciating statement
    array = [self.sql prepareV2:fetchQuery];
    
    return array;
}

-(BOOL)saveUser:(Cart *)user {
    self.sql = [SQLiteModel sharedInstance];
    
    NSString *userQuery = [NSString stringWithFormat: @"UPDATE tbl_Cart SET numberOfNeed = %d WHERE id = %d;UPDATE tbl_Cart SET food_price = %f WHERE id = %d;", user.numberOfNeed, user.id, user.price, user.id];
    char* errMessage = NULL;
    errMessage = [self.sql excute:userQuery andError:errMessage];
    if( errMessage != NULL ) {
        return FALSE;
    }
    
    return TRUE;
}

-(BOOL)deleteUser:(Cart *)user {
    self.sql = [SQLiteModel sharedInstance];
    
    NSString *userQuery = [NSString stringWithFormat: @"DELETE FROM tbl_Cart WHERE id = %d;",user.id];
    char* errMessage = NULL;
    errMessage = [self.sql excute:userQuery andError:errMessage];
    if( errMessage != NULL ) {
        return FALSE;
    }
    
    return TRUE;
}

@end




















