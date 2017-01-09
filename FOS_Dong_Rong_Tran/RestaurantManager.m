//
//  RestaurantManager.m
//  FOS_Dong_Rong_Tran
//
//  Created by YIFU RONG on 1/6/17.
//  Copyright © 2017 rjtcompuquest. All rights reserved.
//

#import "RestaurantManager.h"


@interface RestaurantManager () <NSURLSessionDelegate>

@end

@implementation RestaurantManager

+ (instancetype) sharedInstance {
    static id sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[RestaurantManager alloc] init];
    });
    
    return sharedInstance;
}

- (instancetype) init {
    if(self = [super init] ) {
         self.allRestaurant = [[NSMutableArray alloc] init];
    }
    
    return self;
}


- (void) nearByRestaurantsByLatitude:(NSString *)latitude longitude:(NSString *)longitude radius:(NSString*) radius query:(NSString *) query completionHandler:(void (^)(NSMutableArray* dataArray))completionBlock
{
    
    NSMutableString * urlStr = [NSMutableString  stringWithString: @"https://api.foursquare.com/v2/venues/search?"];
    
    
    NSString *tempRadius = (radius) ? radius : @"2000";
    NSString * ll = [NSString stringWithFormat:@"%@,%@", latitude, longitude];
    NSString *tempQuery = (query) ? query : @"restaurant";
    NSDictionary * parameters = [NSDictionary dictionaryWithObjectsAndKeys:ll, @"ll",
                                 tempRadius,@"radius",
                                 [Constant fourSquareCategoryIdStr],[Constant fourSquareCategoryParam],
                                 tempQuery, @"query",
                                 [Constant fourSquareTokenStr], [Constant fourSquareOauthParam],
                                 [Constant fourSquareVersionStr], [Constant fourSquareVersionParam],
                                 nil];
    
    for (NSString* key in parameters ) {
        [urlStr appendString: key];
        [urlStr appendString: @"="];
        [urlStr appendString: [parameters objectForKey:key]];
        [urlStr appendString:@"&"];
    }
    
    NSURL * queryURL  = [NSURL URLWithString:[urlStr substringToIndex:(urlStr.length - 1)] ];
    
    NSLog(@"\n\n%@", queryURL.absoluteString );
    
    // Session and download
    
    NSURLSessionConfiguration * config = [NSURLSessionConfiguration ephemeralSessionConfiguration];
    NSURLSession * session = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:nil];
    
    NSURLSessionDataTask * task = [session dataTaskWithURL:queryURL completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        NSString * responseMsg = [ [ NSString alloc ] initWithData: data encoding: NSUTF8StringEncoding ];
        id jsonObject = [ NSJSONSerialization JSONObjectWithData: [ responseMsg dataUsingEncoding: NSUTF8StringEncoding ] options:NSJSONReadingAllowFragments error:nil ];
        
        NSMutableArray * dataArray =  [NSMutableArray arrayWithArray: [ (NSDictionary*)[(NSDictionary*)jsonObject objectForKey:@"response"] objectForKey:@"venues"]];
        
        
        for (NSDictionary *venue in dataArray) {
            Restaurant * restaurant = [[Restaurant alloc] init];
            restaurant.name = [NSString stringWithFormat:@"%@",venue[@"name"]];
            restaurant.address = [NSString stringWithFormat:@"%@",venue[@"location"][@"address"]];
            restaurant.latitude = [NSString stringWithFormat:@"%@",venue[@"location"][@"lat"]];
            restaurant.longitude = [NSString stringWithFormat:@"%@",venue[@"location"][@"lng"]];
            restaurant.distance = [NSString stringWithFormat:@"%@",venue[@"location"][@"distance"]];
            
            [self.allRestaurant addObject:restaurant];
        }
        
        if (completionBlock) {
            
            NSMutableArray * retArray = [NSMutableArray arrayWithArray:self.allRestaurant];
            completionBlock (retArray);
        }
    }];
    [task resume];
}

@end
