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



-( void )getFoodMenu:( NSString*)foodCategoryType completionHandler:(void(^)(NSArray* data)) completionBlock
{    
    foodCategoryType = [foodCategoryType stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    NSDictionary * dictParameter = [NSDictionary dictionaryWithObjectsAndKeys:foodCategoryType, @"food_category",
    @"delhi",@"city", nil];
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




-( void)registerByPhone:(NSString*)mobilePhone userName:(NSString*)userName userEmail:(NSString*)userEmail userPassword:(NSString*)userPassword address:(NSString*) address completionHandler:(void(^)(BOOL successful))completionBlock
{
        // // Pass parameters for registration like "user_name=aamir" ," user_email=aa@gmail.com" , “user_phone=55565454", " user_password=7011”, “user_add=Delhi"
    
    
    NSDictionary * userData = [NSDictionary dictionaryWithObjectsAndKeys:
                               mobilePhone, @"user_phone",
                               userPassword, @"user_password",
                               userName, @"user_name",
                               userEmail, @"user_email",
                               address, @"user_add", nil];
    
     [self.provider asyncWebserviceCall:@"fos_reg.php" withDic:userData completionHandler:^(NSString * output){
         BOOL sucessful = ([output isEqualToString:@"successfully registered"]);
         
         if(completionBlock) {
             completionBlock (sucessful);
         }
         
         
     }];
}

-( void )loginByPhone:(NSString*)mobilePhone userPassword:(NSString *)userPassword completionHandler:(void(^)(BOOL successful))completionBlock
{
    //http://rjtmobile.com/ansari/fos/fosapp/fos_login.php?user_phone=123&user_password=123

    NSDictionary * userData = [NSDictionary dictionaryWithObjectsAndKeys:
                               mobilePhone, @"user_phone",
                               userPassword, @"user_password", nil];
        
    //NSString* output = [ self.provider syncWebserviceCall: @"fos_login.php" withDic : userData ];
    
    [self.provider asyncWebserviceCall:@"fos_login.php" withDic:userData completionHandler:^(NSString * output){
        
        id jsonObject = [ NSJSONSerialization JSONObjectWithData: [ output dataUsingEncoding: NSUTF8StringEncoding ] options:NSJSONReadingAllowFragments error:nil ];
        NSArray* data = [ jsonObject objectForKey : @"msg"];
        
        BOOL sucessful = [data[0] isEqualToString:@"success"];
        
        if (completionBlock){
            completionBlock (sucessful);
        }
    }];
    
}

// This could be done better with Order Object. Use it in the mean time
-( void )sendOrderWithMobile:(NSString*)mobileNumber category:(NSString*)foodCategoryType orderName:(NSString*)orderName orderQuantity:(NSString*)orderQuantity totalCost:(NSString*)totalCost orderAddress:(NSString*) orderAddress completionHandler:(void(^)(NSString* order_id))completionBlock
{
    // clean parameter
//    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
//    foodCategoryType = [foodCategoryType stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
//    orderName = [orderName stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
//    orderQuantity = [orderQuantity stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
//    totalCost = [totalCost stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
//    orderAddress = [orderAddress stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    
    NSDateFormatter * dateFormatter  = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd hh:mm:ss"];
    NSDate * now = [NSDate date];
    NSString * dateStr = [NSString stringWithFormat:@"%@", [dateFormatter stringFromDate:now]];
//    dateStr = [dateStr stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    NSLog(@"%@", dateStr);
    
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

-( void )checkOrderHistoryWithMobile:(NSString*)mobileNumber completionHandler:(void(^)(NSArray* data))completionBlock
{
    // clean parameter
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    
    NSDictionary * dictParameter = [NSDictionary dictionaryWithObjectsAndKeys:
                                    mobileNumber, [Constant orderRecentKeyMobile],
                                    nil];
    
    
    [self.provider asyncWebserviceCall:@"order_recent.php" withDic:dictParameter completionHandler:^(NSString * responseMsg) {
        id jsonOject = [NSJSONSerialization JSONObjectWithData:[responseMsg dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:nil];
        
        NSArray * dataArray;
        if ([jsonOject isKindOfClass:[NSDictionary class]]) {
            dataArray = [ ((NSDictionary*)jsonOject) objectForKey: [Constant orderRecentKey]];
        }
        
        if (completionBlock) {
            completionBlock (dataArray);
        }
    }];
}


-( void )checkOrderStatusID:(NSString*)orderID completionHandler:(void(^)(NSArray* data))completionBlock
{
    // clean parameter
    orderID = [orderID stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    
    NSDictionary * dictParameter = [NSDictionary dictionaryWithObjectsAndKeys:
                                    orderID, [Constant orderStatusKeyID],
                                    nil];
    
    
    [self.provider asyncWebserviceCall:@"order_track.php" withDic:dictParameter completionHandler:^(NSString * responseMsg) {
        id jsonOject = [NSJSONSerialization JSONObjectWithData:[responseMsg dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:nil];
        
        NSArray * dataArray;
        if ([jsonOject isKindOfClass:[NSDictionary class]]) {
            dataArray = [ ((NSDictionary*)jsonOject) objectForKey: [Constant orderStatusKey]];
        }
        
        if (completionBlock) {
            completionBlock (dataArray);
        }
    }];
}

-( void )checkComfirmID:(NSString*)orderID completionHandler:(void(^)(NSArray* data))completionBlock
{
    // clean parameter
    orderID = [orderID stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    
    NSDictionary * dictParameter = [NSDictionary dictionaryWithObjectsAndKeys:
                                    orderID, [Constant orderStatusKeyID],
                                    nil];
    
    [self.provider asyncWebserviceCall:@"order_confirmation.php" withDic:dictParameter completionHandler:^(NSString * responseMsg) {
        id jsonOject = [NSJSONSerialization JSONObjectWithData:[responseMsg dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:nil];
        
        NSArray * dataArray;
        if ([jsonOject isKindOfClass:[NSDictionary class]]) {
            dataArray = [ ((NSDictionary*)jsonOject) objectForKey: [Constant orderStatusKey]];
        }
        
        if (completionBlock) {
            completionBlock (dataArray);
        }
    }];
}

-( void )resetPassWordByPhone:(NSString*)phone oldPassword:(NSString *)oldPassword newPassword:(NSString *)newPassword completionHandler:(void(^)(NSArray* data))completionBlock
{
    // clean parameter
    NSDictionary * dictParameter = [NSDictionary dictionaryWithObjectsAndKeys:
                                    phone, @"user_phone",
                                    oldPassword, @"user_password",
                                    newPassword, @"newpassword",
                                    nil];
    
    [self.provider asyncWebserviceCall:@"fos_reset_pass.php" withDic:dictParameter completionHandler:^(NSString * responseMsg) {
        id jsonOject = [NSJSONSerialization JSONObjectWithData:[responseMsg dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:nil];
        
        NSArray * dataArray;
        if ([jsonOject isKindOfClass:[NSDictionary class]]) {
            dataArray = [ ((NSDictionary*)jsonOject) objectForKey: @"msg"];
        }
        if (completionBlock) {
            completionBlock (dataArray);
        }
    }];
}



@end
