//
//  Annotation.m
//  Mapkit
//
//  Created by Pranav Prakash on 12/29/16.
//  Copyright © 2016 Pranav Prakash. All rights reserved.
//

#import "Annotation.h"


@interface Annotation( )
{
    CLLocationCoordinate2D _coordinate;
    NSString *_title;
    NSString *_subtitle;
}

@end

@implementation Annotation



-( instancetype )initWithLatitude : ( double )latitude longitude : ( double )longitude title : ( NSString* )title subtitle : ( NSString* )subtitle
{
    if( ( self = [ super init ] ) )
    {
        _coordinate.longitude = longitude;
        _coordinate.latitude = latitude;
        _title = [ NSString stringWithString: title ];
        _subtitle = [ NSString stringWithString: subtitle ];
        return self;
    }
    return nil;
}

+( instancetype )annotationWithLatitude : ( double )latitude longitude : ( double )longitude title : ( NSString* )title subtitle : ( NSString* )subtitle
{
    return [ [ Annotation alloc ] initWithLatitude: latitude longitude: longitude title:title subtitle:subtitle ];
}


-( CLLocationCoordinate2D )coordinate
{
    return _coordinate;
}

-( NSString* )title
{
    return _title;
}

-( NSString* )subtitle
{
    return _subtitle;
}

@end
