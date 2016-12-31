

#import "WebserviceProvider.h"

@implementation WebserviceProvider


- (NSString *) baseURL
{
    return @"http://rjtmobile.com/ansari/shopingcart/androidapp/";
}

#pragma mark - WebserviceCommunication
- (NSString *) syncWebserviceCall: (NSString *) methodName withDic: (NSDictionary *) parameter
{
    NSMutableString* urlString = [ NSMutableString stringWithString: [ self baseURL ] ];
    [ urlString appendString: methodName ];
    [ urlString appendString: @"?" ];
    for( NSString* key in parameter )
    {
        [ urlString appendFormat: @"%@=%@&", key, [ parameter objectForKey: key ] ];
    }
    NSInteger offset = ([parameter count]) ? 2 : 1;
    NSString* urlStr = [ urlString substringToIndex: urlString.length - 1 ];
    urlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSData* data = [ NSData dataWithContentsOfURL: [ NSURL URLWithString: urlStr ] ];
    return [ [ NSString alloc ] initWithData: data encoding: NSUTF8StringEncoding ];
}

- (NSString *) asyncWebserviceCall: (NSString *) methodName withDic: (NSDictionary *) parameter
{
    NSMutableString* urlString = [ NSMutableString stringWithString: [ self baseURL ] ];
    [ urlString appendString: methodName ];
    [ urlString appendString: @"?" ];
    for( NSString* key in parameter )
    {
        [ urlString appendFormat: @"%@=%@&", key, [ parameter objectForKey: key ] ];
    }
    NSString* urlStr = [ urlString substringToIndex: urlString.length - 2 ];
    urlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSData* data = [ NSData dataWithContentsOfURL: [ NSURL URLWithString: urlStr ] ];
    return [ [ NSString alloc ] initWithData: data encoding: NSUTF8StringEncoding ];
}


@end
