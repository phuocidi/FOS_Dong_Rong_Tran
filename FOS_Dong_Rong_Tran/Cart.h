//
//  Cart.h
//  Test
//
//  Created by YIFU RONG on 12/31/16.
//  Copyright © 2016 Yifu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Cart : NSObject

@property(readwrite, nonatomic) int id;
@property(strong, nonatomic) NSString *name;
@property(strong, nonatomic) NSString *recepiee;
@property(readwrite, nonatomic) int numberOfNeed;
@property(strong, nonatomic) NSString *address;
@property(readwrite, nonatomic) double price;
@property(strong, nonatomic) NSString *thumb;

@end
