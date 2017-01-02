//
//  SQLiteModel.m
//  Test
//
//  Created by YIFU RONG on 12/31/16.
//  Copyright © 2016 Yifu. All rights reserved.
//

#import "SQLiteModel.h"
#import <sqlite3.h>

@interface SQLiteModel ()

@property (assign, nonatomic) sqlite3 *database;
@property (readwrite, nonatomic) int _currentId;

@end

@implementation SQLiteModel

+(instancetype)sharedInstance {
    static id sharedInstance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

-(instancetype)init {
    if (self = [super init]) {
        // init at here
        NSString* directory = [ NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES ) objectAtIndex: 0 ];
        NSString* file = [ directory stringByAppendingPathComponent: @"FOS.db" ];
        NSLog(@"%@", file);
        if( [ [ NSFileManager defaultManager ] fileExistsAtPath: file ] == FALSE )
        {
            [ [ NSFileManager defaultManager ] createFileAtPath: file contents: nil attributes:nil ];
        }
        sqlite3_open( [ file UTF8String ], &_database );
        [ self createTablesNeeded ];
    }
    return self;
}

-( void )createTablesNeeded
{
    NSString* createQuery = @"CREATE TABLE IF NOT EXISTS tbl_Cart (id INTEGER PRIMARY KEY AUTOINCREMENT, user_phone INTEGER NOT NULL, food_category VARCHAR(255) NOT NULL, food_name VARCHAR(255) NOT NULL, food_add VARCHAR(255) NOT NULL, numberOfNeed INTEGER NOT NULL, food_price DOUBLE NOT NULL, food_date VARCHAR(255) NOT NULL);";
    char* errMessage = NULL;
    sqlite3_exec( _database, [ createQuery UTF8String ], NULL, NULL, &errMessage );
    if( errMessage != NULL )
    {
        NSLog( @"%s", errMessage );
    }
    createQuery = @"CREATE TABLE IF NOT EXISTS tbl_Cart (food_id INTEGER PRIMARY KEY, food_name VARCHAR(255) NOT NULL, food_recepiee VARCHAR(255) NOT NULL, numberOfNeed INTEGER NOT NULL, food_price DOUBLE NOT NULL, food_thumb VARCHAR(255) NOT NULL);";
    sqlite3_exec( _database, [ createQuery UTF8String ], NULL, NULL, &errMessage );
    if( errMessage != NULL )
    {
        NSLog( @"%s", errMessage );
    }
}

-(char *)excute:(NSString *)query andError:(char *)errMessage {
    
    NSString* beginTransaction = @"BEGIN TRANSACTION";
    sqlite3_exec( _database, [ beginTransaction UTF8String ], NULL, NULL, NULL );
    
    sqlite3_exec( _database, [ query UTF8String ], NULL, NULL, &errMessage );
    if( errMessage != NULL )
    {
        NSLog(@"%s", errMessage);
        NSString* rollbackTransaction = @"ROLLBACK TRANSACTION";
        sqlite3_exec( _database, [ rollbackTransaction UTF8String ], NULL, NULL, NULL );
    }
    
    NSString* commitTransaction = @"COMMIT TRANSACTION";
    sqlite3_exec( _database, [ commitTransaction UTF8String ], NULL, NULL, NULL );
    
    return errMessage;
}

- (int) sqlType: (char *)name {
    NSString *type_name = [[NSString stringWithFormat:@"%s", name] lowercaseString];
    if ([type_name containsString:@"int"]) {
        return 0;
    }
    if ([type_name containsString:@"double"] || [type_name containsString:@"real"] || [type_name containsString:@"float"]) {
        return 1;
    }
    if ([type_name containsString:@"char"] || [type_name containsString:@"text"] || [type_name containsString:@"clob"]) {
        return 2;
    }
    if ([type_name containsString:@"blob"]) {
        return 3;
    }
    if ([type_name containsString:@"decimal"] || [type_name containsString:@"numeric"]) {
        return 4;
    }
    if ([type_name containsString:@"date"]) {
        return 5;
    }
    
    return -1;
}

-(NSMutableArray *) prepareV2: (NSString *)query{
    sqlite3_stmt* stmt = NULL;
    sqlite3_prepare_v2( _database, [ query UTF8String ], ( int )[ query length ], &stmt, NULL );
    NSMutableArray *resultArray = [[NSMutableArray alloc] init];
    
    while( sqlite3_step( stmt ) == SQLITE_ROW )
    {
        int coloumn_count = sqlite3_column_count(stmt);
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        
        for (int i = 0; i < coloumn_count; i ++) {
            char *coloumn_name = (char *)sqlite3_column_name(stmt, i);
            char *coloumn_type = (char *)sqlite3_column_decltype(stmt, i);
            //            NSLog(@"%s, %s", coloumn_name, coloumn_type);
            
            NSString *col_name = [NSString stringWithUTF8String: coloumn_name];
            int type = [self sqlType: coloumn_type];
            switch (type) {
                case 0: {
                    NSNumber *number = [NSNumber numberWithInt: sqlite3_column_int(stmt, i)];
                    [dic setObject: number forKey:col_name];
                }
                    break;
                case 1: {
                    NSNumber *number = [NSNumber numberWithDouble: sqlite3_column_double(stmt, i)];
                    [dic setObject: number forKey:col_name];
                }
                    break;
                case 2: {
                    NSString *str = [NSString stringWithUTF8String: (char *)sqlite3_column_text(stmt, i)];
                    [dic setObject: str forKey:col_name];
                }
                    break;
                case 3: {
                    NSData *data = [NSData dataWithBytes:sqlite3_column_blob(stmt, i) length:sqlite3_column_bytes(stmt, i)];
                    [dic setObject: data forKey:col_name];
                }
                    break;
                case 4: {
                    // cast to string first, then force change to double
                    NSNumber *number = [NSNumber numberWithDouble: sqlite3_column_double(stmt, i)];
                    [dic setObject: number forKey:col_name];
                }
                    break;
                case 5: {
                    NSString *str = [NSString stringWithUTF8String: (char *)sqlite3_column_text(stmt, i)];
                    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
                    formatter.timeZone = [NSTimeZone localTimeZone];
                    NSDate *date = [formatter dateFromString:str];
                    [dic setObject: date forKey:col_name];
                }
                    break;
                    // date and time are let over
                    
                default:
                    @throw [NSError errorWithDomain:@"Unknow URL Type" code: -1 userInfo: nil];
                    break;
            }
            
        }
        
        [resultArray addObject:dic];
    }
    
    return resultArray;
}

@end




















