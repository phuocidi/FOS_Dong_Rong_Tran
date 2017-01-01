//
//  SQLiteModel.h
//  Test
//
//  Created by YIFU RONG on 12/31/16.
//  Copyright © 2016 Yifu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SQLiteModel : NSObject

+(instancetype)sharedInstance;

-(char *) excute: (NSString *)query andError: (char *) errMessage;
-(NSMutableArray *) prepareV2: (NSString *)query;

@end
