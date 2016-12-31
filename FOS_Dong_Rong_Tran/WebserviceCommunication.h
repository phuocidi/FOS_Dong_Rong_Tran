

#import <Foundation/Foundation.h>

@protocol WebserviceCommunication <NSObject>

- (NSString *) baseURL;
- (NSString *) syncWebserviceCall: (NSString *) methodName withDic: (NSDictionary *) parameter;
- (NSString *) asyncWebserviceCall: (NSString *) methodName withDic: (NSDictionary *) parameter;

@end























