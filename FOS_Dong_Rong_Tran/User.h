//
//  User.h
//  Test
//
//  Created by YIFU RONG on 12/31/16.
//  Copyright © 2016 Yifu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

@property(readwrite, nonatomic) int phone;
@property(strong, nonatomic) NSString *name;
@property(strong, nonatomic) NSString *email;
@property(strong, nonatomic) NSString *password;
@property(strong, nonatomic) NSString *address;
@property(readwrite, nonatomic) double longitude;
@property(readwrite, nonatomic) double latitude;

@end
