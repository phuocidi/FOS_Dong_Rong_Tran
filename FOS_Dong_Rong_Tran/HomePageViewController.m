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

#define METERS_PER_MILE     1609.34
#define EPSILON             0.000001

@interface HomePageViewController () < MKMapViewDelegate, LocationChanged>
{
    CLLocationCoordinate2D _coordinate;
}
@property ( strong )Annotation* myAnnotation;
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
        if( self.myAnnotation != nil )
        {
            [ self.mapView removeAnnotation: self.myAnnotation ];
        }
        self.myAnnotation = [ Annotation annotationWithLatitude: coordinate.latitude longitude:coordinate.longitude title:@"My Location" subtitle:@"subtitle"];
//        self.myAnnotation.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
//        self.myAnnotation.canShowCallout = YES;
        [ self.mapView addAnnotation: self.myAnnotation ];
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
    [ self.mapView addAnnotation: [ Annotation annotationWithLatitude: 39.281516 longitude:-76.580806 title:@"Title1" subtitle:@"subtitle"] ];
    [ self.mapView addAnnotation: [ Annotation annotationWithLatitude: 39.3 longitude:-76.580806 title:@"Title2" subtitle:@"subtitle"] ];
    [ self.mapView addAnnotation: [ Annotation annotationWithLatitude: 39.33 longitude:-76.580806 title:@"Title3" subtitle:@"subtitle"] ];
    
    self.mapView.mapType = MKMapTypeStandard;
}
- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    view.selected = YES;
    NSLog(@"select an annotation");
//    FoodMenuViewController * vc = [self.storyboard instantiateViewControllerWithIdentifier:@"FoodMenuViewController"];
//    
//    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - click title

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    NSLog(@"calloutAccessoryControlTapped");
        FoodMenuViewController * vc = [self.storyboard instantiateViewControllerWithIdentifier:@"FoodMenuViewController"];
    
    // Add location to User Model
    User *user = [User sharedInstance];
    user.latitude = _coordinate.latitude;
    user.longitude = _coordinate.longitude;
    
    [self.navigationController pushViewController:vc animated:YES];
}


- (nullable MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
//    MKAnnotationView* result = [ mapView dequeueReusableAnnotationViewWithIdentifier: @"Markers" ];
    MKPinAnnotationView *result = (MKPinAnnotationView *) [mapView dequeueReusableAnnotationViewWithIdentifier: @"asdf"];
    if( result == nil )
        result = [ [ MKPinAnnotationView alloc ] initWithAnnotation: annotation reuseIdentifier:@"Markers" ];
    else
        result.annotation = annotation;
    result.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];

//    UIImage* image = nil;
    if( [annotation.title isEqualToString: @"My Location" ] ) {
        result.pinTintColor = [MKPinAnnotationView purplePinColor];
        result.draggable = YES;
        result.animatesDrop = YES;
    }
    else
            result.pinTintColor = [MKPinAnnotationView redPinColor];
//    result.image = image;
    result.canShowCallout = YES;
    
    return result;
}

#pragma mark - pin draggable
-(void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view didChangeDragState:(MKAnnotationViewDragState)newState fromOldState:(MKAnnotationViewDragState)oldState {
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
