//
//  Annotation.h
//  Mapkit
//
//  Created by Pranav Prakash on 12/29/16.
//  Copyright © 2016 Pranav Prakash. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "Restaurant.h"
@interface Annotation : MKPointAnnotation < MKAnnotation >


//-( instancetype )initWithLatitude : ( double )latitude longitude : ( double )longitude title : ( NSString* )title subtitle : ( NSString* )subtitle;

//+( instancetype )annotationWithLatitude : ( double )latitude longitude : ( double )longitude title : ( NSString* )title subtitle : ( NSString* )subtitle;

//@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
//@property (nonatomic, readonly, copy, nullable) NSString *title;
//@property (nonatomic, readonly, copy, nullable) NSString *subtitle;
@property (strong, nonatomic) Restaurant * restaurant;

-( instancetype )initWithRestaurant: (Restaurant*)restaurant;

@end
