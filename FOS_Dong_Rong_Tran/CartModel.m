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

-(BOOL)createUser:(int)food_id name:(NSString *)food_name recepiee:(NSString *)food_recepiee number:(int)numberOfNeed image:(NSString *)food_thumb price:(double)food_price {
    
    self.sql = [SQLiteModel sharedInstance];
    
    NSString* userQuery = @"INSERT INTO tbl_Cart VALUES( 707, 'Chicken tikka meatballs', 'chicken tikka meatballs, chopped tomato makh', 1, 1550, 'Image URL');INSERT INTO tbl_Cart VALUES( 708, 'Chettinad chicken keema', 'chettinad chicken keema, curry leaf lemon se', 1, 1650, 'Image URL');";
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
    
    NSString* userQuery = @"UPDATE tbl_Cart SET numberOfNeed = 2, WHERE food_id = 708;";
    char* errMessage = NULL;
    errMessage = [self.sql excute:userQuery andError:errMessage];
    if( errMessage != NULL ) {
        return FALSE;
    }
    
    return TRUE;
}

@end




















