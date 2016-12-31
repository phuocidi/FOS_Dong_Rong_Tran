#import "WebService.h"
#import "WebserviceProvider.h"
#import "Constant.h"

//1.       Login
//http://rjtmobile.com/ansari/fos/fosapp/fos_login.php&user_phone=55565454&user_password=7011
//
//2.       Registration
//http://rjtmobile.com/ansari/fos/fosapp/fos_reg.php?&user_name=aamir&user_email=aa@gmail.com&user_phone=55565454&user_password=7011&user_add=Delhi
//
//3.       Reset password
//http://rjtmobile.com/ansari/fos/fosapp/fos_reset_pass.php?&user_phone=55565454&user_password=7011&newpassword=7012
//
//4.       Food list by category: veg, non-veg
//http://rjtmobile.com/ansari/fos/fosapp/fos_food.php?food_category=veg
//http://rjtmobile.com/ansari/fos/fosapp/fos_food.php?food_category=non-veg
//
//5.       Order Request
//http://rjtmobile.com/ansari/fos/fosapp/order_request.php?&order_category=veg&order_name=Biryani&order_quantity=2&total_order=700&order_delivery_add=noida&order_date=2016-12-21 11:32:56&user_phone=55565454
//
//6.       Order Confirmation
//http://rjtmobile.com/ansari/fos/fosapp/order_confirmation.php?&order_id=12222228
//
//7.       Order Recent
//http://rjtmobile.com/ansari/fos/fosapp/order_recent.php?&user_phone=55565454
//
//8.       Order Track
//http://rjtmobile.com/ansari/fos/fosapp/order_track.php?&order_id=12222228
//
//
//If "OrderStatus":"1" its means Packing
//
//If "OrderStatus":"2" its means On the way
//
//If "OrderStatus":"3" its means Delivered


@interface WebService( )

@property ( nonatomic, retain ) id < WebserviceCommunication > provider;

@end

@implementation WebService


+( instancetype )sharedInstance
{
    static WebService* mfs_Instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mfs_Instance = [ [ WebService alloc ] init ];
        mfs_Instance.provider = [ [ WebserviceProvider alloc ] init ];
    });
    return mfs_Instance;
}



-( void )getCategory:( NSString*)foodCategoryType completionHandler:(void(^)(NSArray* data)) completionBlock
{    

    NSDictionary * dictParameter = [NSDictionary dictionaryWithObjectsAndKeys:foodCategoryType, @"food_category", nil];
    [self.provider asyncWebserviceCall:@"fos_food.php" withDic:dictParameter completionHandler:^(NSString * responseMsg) {
        
        id jsonObject = [ NSJSONSerialization JSONObjectWithData: [ responseMsg dataUsingEncoding: NSUTF8StringEncoding ] options:NSJSONReadingAllowFragments error:nil ];
        
        NSArray * dataArray = [((NSDictionary*) jsonObject) objectForKey:[Constant foodKey]];
        
        // REFACTOR. YiFu, it's your call here
        // Should let ModelManager add object here and don't call the code below?
        if (completionBlock) {
            completionBlock (dataArray);
        }
    }];
}

-( void )getSubCategoryByID:(NSInteger)sid
{
    NSDictionary * dict = [NSDictionary dictionaryWithObject:[NSNumber numberWithInteger: sid] forKey:@"Id"];
    NSString* output = [ self.provider syncWebserviceCall: @"cust_sub_category.php" withDic : dict];
    
    id jsonObject = [ NSJSONSerialization JSONObjectWithData: [ output dataUsingEncoding: NSUTF8StringEncoding ] options:NSJSONReadingAllowFragments error:nil ];
    
    
}

-( void )getProductByID:(NSInteger)sid
{
    NSDictionary * dict = [NSDictionary dictionaryWithObject:[NSNumber numberWithInteger: sid] forKey:@"Id"];
    NSString* output = [ self.provider syncWebserviceCall: @"cust_product.php" withDic : dict];
    
    id jsonObject = [ NSJSONSerialization JSONObjectWithData: [ output dataUsingEncoding: NSUTF8StringEncoding ] options:NSJSONReadingAllowFragments error:nil ];
    
    NSArray* data = [ jsonObject objectForKey : @"Product"];
    
    
}



-( NSString* )registerUser:(NSDictionary*) userData
{
    NSString* output = [ self.provider syncWebserviceCall: @"shop_reg.php" withDic : userData ];

    return output;
}

-( NSString* )loginUser:(NSDictionary*) userData
{
    NSString* output = [ self.provider syncWebserviceCall: @"shop_login.php" withDic : userData ];
    
    id jsonObject = [ NSJSONSerialization JSONObjectWithData: [ output dataUsingEncoding: NSUTF8StringEncoding ] options:NSJSONReadingAllowFragments error:nil ];
    //NSArray* data = [ jsonObject objectForKey : @"msg"];
    if ([jsonObject isKindOfClass:[NSDictionary class]]) {
        return @"failed";
    }
    else {
        return @"sucessful";
    }
    return output;
}


-( NSString* )sendOrder:(NSDictionary*) orderData
{
    NSString* output = [ self.provider syncWebserviceCall: @"orders.php" withDic : orderData ];
    
    id jsonObject = [ NSJSONSerialization JSONObjectWithData: [ output dataUsingEncoding: NSUTF8StringEncoding ] options:NSJSONReadingAllowFragments error:nil ];
    
    NSArray* data = [ jsonObject objectForKey : @"Order Confirmed"];
    
    return [data[0] objectForKey:@"OrderId"];
}

@end
