
#import <Foundation/Foundation.h>
#import "WebserviceCommunication.h"

@interface WebserviceProvider : NSObject < WebserviceCommunication,NSURLSessionDelegate >

- (void) asyncWebserviceCall: (NSString *) serviceName withDic: (NSDictionary *) parameter completionHandler:(void (^)(NSString* response))completionBlock;

@end
