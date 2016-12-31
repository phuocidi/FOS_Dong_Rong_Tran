

#import <Foundation/Foundation.h>

@protocol WebserviceCommunication <NSObject>

- (NSString *) baseURL;
- (NSString *) syncWebserviceCall: (NSString *) methodName withDic: (NSDictionary *) parameter;

- ( void) asyncWebserviceCall: (NSString *) serviceName withDic: (NSDictionary *) parameter completionHandler:(void (^)(NSString*))completionHandler;

@end























