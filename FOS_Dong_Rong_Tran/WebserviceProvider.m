

#import "WebserviceProvider.h"

@implementation WebserviceProvider 


- (NSString *) baseURL
{
    return @"http://rjtmobile.com/ansari/fos/fosapp/";
}

#pragma mark - WebserviceCommunication
- (NSString *) syncWebserviceCall: (NSString *) serviceName withDic: (NSDictionary *) parameter
{
    NSMutableString* urlString = [ NSMutableString stringWithString: [ self baseURL ] ];
    [ urlString appendString: serviceName ];
    [ urlString appendString: @"?" ];
    for( NSString* key in parameter )
    {
        [ urlString appendFormat: @"%@=%@&", key, [ parameter objectForKey: key ] ];
    }
    NSInteger offset = ([parameter count]) ? 2 : 1;
    NSString* urlStr = [ urlString substringToIndex: urlString.length - 1 ];
    urlStr = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSData* data = [ NSData dataWithContentsOfURL: [ NSURL URLWithString: urlStr ] ];
    return [ [ NSString alloc ] initWithData: data encoding: NSUTF8StringEncoding ];
}

- (void) asyncWebserviceCall: (NSString *) serviceName withDic: (NSDictionary *) parameter completionHandler:(void (^)(NSString* response))completionBlock
{
    NSMutableString* urlString = [ NSMutableString stringWithString: [ self baseURL ] ];
    [ urlString appendString: serviceName ];
    [ urlString appendString: @"?" ];
    for( NSString* key in parameter )
    {
        [ urlString appendFormat: @"%@=%@&", key, [ parameter objectForKey: key ] ];
    }
    
    NSString* urlStr = [ urlString substringToIndex: urlString.length - 1 ];
    urlStr = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];

    NSURL * url = [NSURL URLWithString:urlStr];
    
    NSURLSessionConfiguration * config = [NSURLSessionConfiguration ephemeralSessionConfiguration];
    NSURLSession * session = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:nil];
    NSURLSessionDataTask * task = [session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if(!error) {
            
            NSString * responseMsg = [ [ NSString alloc ] initWithData: data encoding: NSUTF8StringEncoding ];
        if (completionBlock) {
                completionBlock(responseMsg);
            }
        }else{
            NSLog(@"[ERROR] [WebserviceProvider - (void) asyncWebserviceCall: (NSString *) serviceName withDic: (NSDictionary *) parameter completionHandler:(void (^)(NSString*))completionBlock] reason: %@", error);
        }
    }];
    
    [task resume];

    
}


@end
