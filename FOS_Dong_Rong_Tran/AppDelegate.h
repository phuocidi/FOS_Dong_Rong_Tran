//
//  AppDelegate.h
//  Mapkit
//
//  Created by Pranav Prakash on 12/29/16.
//  Copyright © 2016 Pranav Prakash. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>


extern CLLocationManager* locationManager( );


@protocol LocationChanged <NSObject>

-( void )apply : ( CLLocationCoordinate2D )coordinate;

@end


@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property( strong ) CLLocationManager* manager;
@property ( weak ) id < LocationChanged > locationChanged;


@end

