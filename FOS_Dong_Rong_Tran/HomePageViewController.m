
//
//  ViewController.m
//  Mapkit
//
//  Created by Pranav Prakash on 12/29/16.
//  Copyright © 2016 Pranav Prakash. All rights reserved.
//

#import "HomePageViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "Annotation.h"
#import "AppDelegate.h"
#import "FoodMenuViewController.h"
#import "User.h"
#import "Restaurant.h"
#import  "UIViewController+AMSlideMenu.h"
#import "Constant.h"
#import "RestaurantManager.h"

#define METERS_PER_MILE     1609.34
#define EPSILON             0.000001

@interface HomePageViewController () < MKMapViewDelegate, LocationChanged>
{
    CLLocationCoordinate2D _coordinate;
}
@property ( strong )MKPointAnnotation* myCurrentLocation;
@property(strong, nonatomic) NSArray *nearby;
@end
//---------------------------------------------
@implementation HomePageViewController
-( BOOL )isChanged : ( CLLocationCoordinate2D )old newLocation : ( CLLocationCoordinate2D )newValue
{
    double latDiff = old.latitude - newValue.latitude;
    double longDiff = old.longitude - newValue.longitude;
    if( latDiff > EPSILON || longDiff > EPSILON )
    {
        return TRUE;
    }
    return FALSE;
}


-( void )apply:(CLLocationCoordinate2D)coordinate
{
    if( [ self isChanged : _coordinate newLocation : coordinate ] )
    {
        _coordinate = coordinate;
        float ASPECTRATIONOFMAPKIT = self.mapView.frame.size.width / self.mapView.frame.size.height;
        MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance( _coordinate, 0.5 * METERS_PER_MILE, 0.5 * METERS_PER_MILE * ASPECTRATIONOFMAPKIT );
        [ self.mapView setRegion: region animated: YES ];
        if( self.myCurrentLocation != nil )
        {
            [ self.mapView removeAnnotation: self.myCurrentLocation ];
        }
        
        // self.myAnnotation = [ Annotation annotationWithLatitude: coordinate.latitude longitude:coordinate.longitude title:@"My Location" subtitle:@"subtitle"];
        self.myCurrentLocation = [[MKPointAnnotation alloc] init];
        self.myCurrentLocation.coordinate = _coordinate;
        self.myCurrentLocation.title = @"My Location";
        
        //        self.myAnnotation.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        //        self.myAnnotation.canShowCallout = YES;
        [ self.mapView addAnnotation: self.myCurrentLocation ];
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.mapView.delegate = self;
    _coordinate.longitude = -76.580806;
    _coordinate.latitude = 39.281516;
    ( ( AppDelegate* )[ UIApplication sharedApplication ].delegate ).locationChanged = self;
    float ASPECTRATIONOFMAPKIT = self.mapView.frame.size.width / self.mapView.frame.size.height;
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance( _coordinate, 0.5 * METERS_PER_MILE, 0.5 * METERS_PER_MILE * ASPECTRATIONOFMAPKIT );
    
    
    [ self.mapView setRegion: region ];
    
    self.nearby = [[RestaurantManager sharedInstance] allRestaurant];
    
    if (self.nearby.count) {
        for (Restaurant *restaurant in self.nearby) {
            
            [self.mapView addAnnotation:[[Annotation alloc]initWithRestaurant: restaurant ]];
        }
    }else {
        AppDelegate * appDelegate = (AppDelegate *) [ [UIApplication sharedApplication] delegate];
        CLLocationManager *manager = [appDelegate manager];
        
        CGFloat lat = manager.location.coordinate.latitude;
        CGFloat lng = manager.location.coordinate.longitude;
        
        NSString * latitude = [NSString stringWithFormat:@"%0.6f", lat];
        NSString * longitude = [NSString stringWithFormat:@"%0.6f", lng];
        
        [[RestaurantManager sharedInstance] nearByRestaurantsByLatitude:latitude longitude:longitude radius:@"800" query:nil completionHandler:^(NSMutableArray *dataArray) {
            self.nearby = [[RestaurantManager sharedInstance] allRestaurant];
            for (Restaurant *restaurant in self.nearby) {
                
                [self.mapView addAnnotation:[[Annotation alloc]initWithRestaurant: restaurant ]];
            }
        }];
    }
    
    
    self.mapView.mapType = MKMapTypeStandard;
}
- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    view.selected = YES;
    NSLog(@"select an annotation");
    NSLog(@"%@",view.annotation);
    [self.nearby indexOfObject: view.annotation];
    MKPointAnnotation * annotation = view.annotation;
    
    if ( ![annotation.title isEqualToString:@"My Location"]) {
        [RestaurantManager sharedInstance].currentRestaurant = [((Annotation*)annotation) restaurant];
    }
    
    //NSLog(@"%@", annotation.restaurant);
    //    FoodMenuViewController * vc = [self.storyboard instantiateViewControllerWithIdentifier:@"FoodMenuViewController"];
    //
    //    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - click title

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    NSLog(@"calloutAccessoryControlTapped");
    
    // Add location to User Model
    User *user = [User sharedInstance];
    user.latitude = _coordinate.latitude;
    user.longitude = _coordinate.longitude;
    
    AMSlideMenuMainViewController *mainVC = [self mainSlideMenu];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:2 inSection:0];
    [mainVC openContentViewControllerForMenu:AMSlideMenuLeft atIndexPath:indexPath];
}


- (nullable MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{

    if( [annotation.title isEqualToString: @"My Location" ] ) {
        MKPinAnnotationView *result = (MKPinAnnotationView *) [mapView dequeueReusableAnnotationViewWithIdentifier: @"asdf"];
        if( result == nil )
            result = [ [ MKPinAnnotationView alloc ] initWithAnnotation: annotation reuseIdentifier:@"Markers" ];
        else
            result.annotation = annotation;
        result.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        
        result.pinTintColor = [MKPinAnnotationView purplePinColor];
        result.draggable = YES;
        result.animatesDrop = YES;
        result.canShowCallout = YES;
        return result;
    }
    else{
        MKAnnotationView *result = (MKAnnotationView *) [mapView dequeueReusableAnnotationViewWithIdentifier: @"restaurant"];
        if( result == nil )
            result = [ [ MKAnnotationView alloc ] initWithAnnotation: annotation reuseIdentifier:@"restaurant" ];
        else
        result.annotation = annotation;
        result.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        result.draggable = YES;
        result.image = [UIImage imageNamed:@"restaurantMarker"];
        result.canShowCallout = YES;
        return result;
    }
}

#pragma mark - pin draggable
-(void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view didChangeDragState:(MKAnnotationViewDragState)newState fromOldState:(MKAnnotationViewDragState)oldState {
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) nearByRestaurantsByLatitude:(NSString *)latitude longitude:(NSString *)longitude radius:(NSString*) radius query:(NSString *) query
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
        [urlStr stringByAppendingString: [parameters objectForKey:key]];
        [urlStr stringByAppendingString:@"&"];
    }
    
    NSURL * queryURL  = [NSURL URLWithString:[urlStr substringToIndex:(urlStr.length - 1)] ];
    
    NSLog(@"\n\n%@", queryURL.absoluteString );
    
    // Session and download
    
    NSURLSessionConfiguration * config = [NSURLSessionConfiguration ephemeralSessionConfiguration];
    NSURLSession * session = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:nil];
    
    NSURLSessionDataTask * task = [session dataTaskWithURL:queryURL];
    [task resume];
}


@end
