

#import <Foundation/Foundation.h>
#import "WebserviceCommunication.h"
@interface WebService : NSObject

+( instancetype )sharedInstance;

-( void )getFoodMenu:( NSString*)foodCategoryType completionHandler:(void(^)(NSArray* data)) completionBlock;

-( void )sendOrderWithMobile:(NSString*)mobileNumber category:(NSString*)foodCategoryType orderName:(NSString*)orderName orderQuantity:(NSString*)orderQuantity totalCost:(NSString*)totalCost orderAddress:(NSString*) orderAddress completionHandler:(void(^)(NSString* order_id))completionBlock;

-( void )checkOrderHistoryWithMobile:(NSString*)mobileNumber completionHandler:(void(^)(NSArray* data))completionBlock;

-( void )checkOrderStatusID:(NSString*)orderID completionHandler:(void(^)(NSArray* data))completionBlock;

-( void )checkComfirmID:(NSString*)orderID completionHandler:(void(^)(NSArray* data))completionBlock;

- ( NSString* )registerUser:(NSDictionary*) data;

-( NSString* )loginUser:(NSDictionary*) data;

@end
