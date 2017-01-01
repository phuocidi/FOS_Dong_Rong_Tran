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
    foodCategoryType = [foodCategoryType stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSDictionary * dictParameter = [NSDictionary dictionaryWithObjectsAndKeys:foodCategoryType, @"food_category", nil];
    [self.provider asyncWebserviceCall:@"fos_food.php" withDic:dictParameter completionHandler:^(NSString * responseMsg) {
        
        id jsonObject = [ NSJSONSerialization JSONObjectWithData: [ responseMsg dataUsingEncoding: NSUTF8StringEncoding ] options:NSJSONReadingAllowFragments error:nil ];
        
        NSArray * dataArray;
        
        if ([jsonObject isKindOfClass:[NSDictionary class]]) {
            dataArray = [((NSDictionary*) jsonObject) objectForKey:[Constant foodKey]];
        }
        
        // REFACTOR. YiFu, it's your call here
        // Should let ModelManager add object here and don't call the code below?
        if (completionBlock) {
            completionBlock (dataArray);
        }
    }];
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


//&order_category=veg&order_name=Biryani&order_quantity=2&total_order=700&order_delivery_add=noida&order_date=2016-12-21 11:32:56&user_phone=55565454

// This could be done better with Order Object. Use it in the mean time
-( void )sendOrderWithMobile:(NSString*)mobileNumber category:(NSString*)foodCategoryType orderName:(NSString*)orderName orderQuantity:(NSString*)orderQuantity totalCost:(NSString*)totalCost orderAddress:(NSString*) orderAddress completionHandler:(void(^)(NSString* order_id))completionBlock
{
    // clean parameter
    mobileNumber = [mobileNumber stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    foodCategoryType = [foodCategoryType stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    orderName = [orderName stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    orderQuantity = [orderQuantity stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    totalCost = [totalCost stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    orderAddress = [orderAddress stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    NSDateFormatter * dateFormatter  = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd hh:mm a"];
    NSDate * now = [NSDate date];
    NSString * dateStr = [NSString stringWithFormat:@"%@", [dateFormatter stringFromDate:now]];
    dateStr = [dateStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    NSDictionary * dictParameter = [NSDictionary dictionaryWithObjectsAndKeys:
                                    mobileNumber, [Constant orderKeyMobile],
                                    foodCategoryType,[Constant orderKeyCategory],
                                    orderName,[Constant orderKeyName],
                                    orderQuantity,[Constant orderKeyQuantity],
                                    totalCost,[Constant orderKeyTotal],
                                    orderAddress,[Constant orderKeyAddress],
                                    dateStr,[Constant orderKeyDate],nil];
    
    
    [self.provider asyncWebserviceCall:@"order_request.php" withDic:dictParameter completionHandler:^(NSString * responseMsg) {
        
        NSString * order_id = [[ responseMsg componentsSeparatedByString:@":"] lastObject];
        order_id = [order_id stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        if (completionBlock) {
            completionBlock (order_id);
        }
    }];
    
    
}

@end
