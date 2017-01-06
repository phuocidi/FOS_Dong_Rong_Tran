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
    }
    return self;
}

+ (NSArray *)getAllRestaurant {
    NSMutableArray <Restaurant*> *allRestaurant = [[NSMutableArray alloc] init];
    
//    allRestaurant = @{@{39.281516,-76.580806}};
    Restaurant * dummy = [[Restaurant alloc] init];
    dummy.longitude = @"-76.580806";
    dummy.latitude = @"39.281516";
    dummy.name = @"RJT";
    [allRestaurant addObject:dummy];
    
    Restaurant * dummy1 = [[Restaurant alloc] init];
    dummy1.longitude = @"-76.580906";
    dummy1.latitude = @"39.281616";
    dummy1.name = @"RJT - 1";
    [allRestaurant addObject:dummy1];
    
//    [[WebserviceProvider alloc] asyncWebserviceCall:<#(NSString *)#> withDic:<#(NSDictionary *)#> completionHandler:^(NSString *response) {
//        
//    }];
    
    return allRestaurant;
}

- (NSString *) description {
    return [NSString stringWithFormat:@"Restaurant name:\t%@\nlongitude:\t%@\nlatitude:\t%@",
            self.name, self.longitude, self.latitude];
}
@end













