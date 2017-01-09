//
//  Restaurant.m
//  FOS_Dong_Rong_Tran
//
//  Created by YIFU RONG on 1/6/17.
//  Copyright © 2017 rjtcompuquest. All rights reserved.
//

#import "Restaurant.h"
#import "WebserviceProvider.h"

@implementation Restaurant

- (instancetype)initWithDictionary:(NSDictionary *)dic {
    if (self = [super init]) {
        self.name = dic[@"name"];
        self.latitude = dic[@"latitude"];
        self.longitude = dic[@"longitude"];
        self.address = dic[@"address"];
    }
    return self;
}


- (NSString *) description {
    return [NSString stringWithFormat:@"\nRestaurant name:\t%@\nlongitude:\t%@\nlatitude:\t%@\naddress:\t%@",
            self.name, self.longitude, self.latitude, self.address];
}

@end













