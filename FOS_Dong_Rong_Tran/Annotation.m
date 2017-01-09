//
//  Annotation.m
//  Mapkit
//
//  Created by Pranav Prakash on 12/29/16.
//  Copyright © 2016 Pranav Prakash. All rights reserved.
//

#import "Annotation.h"


@interface Annotation( )

@end

@implementation Annotation

- (instancetype)initWithRestaurant:(Restaurant *)restaurant {
    
    if(self = [super init]) {
        self.restaurant = restaurant;
        self.title = [NSString stringWithString: self.restaurant.name];
        self.subtitle = [NSString stringWithString: self.restaurant.address];
        self.coordinate = CLLocationCoordinate2DMake([self.restaurant.latitude doubleValue], [self.restaurant.longitude doubleValue]);
    }
    return self;
}

@end
