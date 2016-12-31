

#import <Foundation/Foundation.h>
#import "WebserviceCommunication.h"
@interface WebService : NSObject

+( instancetype )sharedInstance;

-( void )getCategory:( NSString*)foodCategoryType completionHandler:(void(^)(NSArray*)) completionBlock;

- ( NSString* )registerUser:(NSDictionary*) data;

-( NSString* )loginUser:(NSDictionary*) data;

- ( void )getSubCategoryByID:(NSInteger)sid;

-( void )getProductByID:(NSInteger)sid;

-( NSString* )sendOrder:(NSDictionary*) orderData;
@end
