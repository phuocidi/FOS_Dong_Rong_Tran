//
//  AppDelegate.m
//  Mapkit
//
//  Created by Pranav Prakash on 12/29/16.
//  Copyright © 2016 Pranav Prakash. All rights reserved.
//

#import "AppDelegate.h"
#import "PayPalMobile.h"
#import "RestaurantManager.h"

extern CLLocationManager* locationManager( )
{
    return [ ( ( AppDelegate* )[ [ UIApplication sharedApplication ] delegate ] ) manager ];
}

@interface AppDelegate () < CLLocationManagerDelegate >

@end

@implementation AppDelegate


- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray<CLLocation *> *)location
{
    CLLocationCoordinate2D coordinate = [ location lastObject ].coordinate;
    [ self.locationChanged apply: coordinate ];
}


- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    if( status == kCLAuthorizationStatusAuthorizedAlways )
    {
        [ self.manager startUpdatingLocation ];
    }
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"hasLauched"];
    
    // Override point for customization after application launch.
    self.manager = [ [ CLLocationManager alloc ] init ];
    self.manager.delegate = self;
    [ self.manager requestAlwaysAuthorization ];
    [PayPalMobile initializeWithClientIdsForEnvironments:@{PayPalEnvironmentSandbox : @"AVL04iyZxgRxlKsnepyRZXQQSJVl8qARtR-BGMQO7JbAYte__hVgdSxqiMIVcRuG9x9IIDr79OvJn0IB"}];
    return YES;
}



- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"hasLauched"];
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
