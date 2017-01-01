//
//  Constant.h
//  FOS_Dong_Rong_Tran
//
//  Created by Huu Tran on 12/30/16.
//  Copyright © 2016 rjtcompuquest. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Constant : NSObject

+ (NSString*) foodKeyID;
+ (NSString*) foodKeyName;
+ (NSString*) foodKeyPrice;
+ (NSString*) foodKeyRecepiee;
+ (NSString*) foodKeyImgURL;
+ (NSString *) foodKeyCategoryVeg;
+ (NSString *)  foodKeyCategoryNonVeg;
+ (NSString *)  foodKey;


+ (NSString*) orderKeyName;
+ (NSString*) orderKeyMobile;
+ (NSString*) orderKeyQuantity;
+ (NSString*) orderKeyTotal;
+ (NSString*) orderKeyAddress;
+ (NSString*) orderKeyDate;
+ (NSString*) orderKeyCategory;


+ (NSString*) orderRecentKey;
+ (NSString*) orderRecentKeyID;
+ (NSString*) orderRecentKeyName;
+ (NSString*) orderRecentKeyQuantity;
+ (NSString*) orderRecentKeyTotal;
+ (NSString*) orderRecentKeyStatus;
+ (NSString*) orderRecentKeyAddress;
+ (NSString*) orderRecentKeyDate;
+ (NSString*) orderRecentKeyMobile;

+ (NSString*) orderStatusKeyID;
+ (NSString*) orderStatusKey;
@end
