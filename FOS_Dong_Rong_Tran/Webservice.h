

#import <Foundation/Foundation.h>
#import "WebserviceCommunication.h"
@interface WebService : NSObject

+( instancetype )sharedInstance;

-( void )getCategory:( NSString*)foodCategoryType completionHandler:(void(^)(NSArray*)) completionBlock;

-( void )sendOrderWithMobile:(NSString*)mobileNumber category:(NSString*)foodCategoryType orderName:(NSString*)orderName orderQuantity:(NSString*)orderQuantity totalCost:(NSString*)totalCost orderAddress:(NSString*) orderAddress completionHandler:(void(^)(NSString* order_id))completionBlock;

-( void )checkRecentOrderWithMobile:(NSString*)mobileNumber completionHandler:(void(^)(NSArray* data))completionBlock;

- ( NSString* )registerUser:(NSDictionary*) data;

-( NSString* )loginUser:(NSDictionary*) data;

@end
