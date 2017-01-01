//
//  UserModel.m
//  Test
//
//  Created by YIFU RONG on 12/31/16.
//  Copyright © 2016 Yifu. All rights reserved.
//

#import "UserModel.h"
#import "SQLiteModel.h"

@interface UserModel()

@property (strong, nonatomic) SQLiteModel *sql;

@end

@implementation UserModel

-(BOOL)createUser:(int)user_phone name:(NSString *)user_name email:(NSString *)user_email password:(NSString *)user_password add:(NSString *)user_add longtitude:(double)user_longitude latitude:(double)user_latitude {
    
    self.sql = [SQLiteModel sharedInstance];
    
    NSString* userQuery = @"INSERT INTO tbl_User VALUES( 1, 'Yifu Rong', 'yifu@gamil.com', '123', 'Michigan', -88.2024, 41.5359);INSERT INTO tbl_User VALUES( 2, 'Huu Tran', 'huu@gmail.com', '123', 'Chicago', -88.2023, 41.5358);INSERT INTO tbl_User VALUES( 3, 'Yupeng Dong', 'yupeng@gmail.com', '123', 'Chicago', -88.2025, 41.5360);";
    char* errMessage = NULL;
    errMessage = [self.sql excute:userQuery andError:errMessage];
    if( errMessage != NULL ) {
        return FALSE;
    }
    
    return TRUE;
}

-(NSMutableArray *)allUsers
{
    self.sql = [SQLiteModel sharedInstance];
    NSMutableArray* array = [ NSMutableArray array ];
    NSString* fetchQuery = [ NSString stringWithFormat : @"SELECT * FROM tbl_User;" ];
    
    // instanciating statement
    array = [self.sql prepareV2:fetchQuery];
    
    return array;
}

-(BOOL)saveUser:(User *)user {
    
    self.sql = [SQLiteModel sharedInstance];
    
    NSString* userQuery = @"UPDATE tbl_User SET user_add = 'Michigen' WHERE user_phone = 1;";
    char* errMessage = NULL;
    errMessage = [self.sql excute:userQuery andError:errMessage];
    if( errMessage != NULL ) {
        return FALSE;
    }
    
    return TRUE;
}

@end




















