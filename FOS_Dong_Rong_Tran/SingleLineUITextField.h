//
//  SingleLineUITextField.h
//  ecommerce
//
//  Created by Huu Tran on 12/21/16.
//  Copyright © 2016 rjtcompuquest. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AMPopTip.h"

@interface SingleLineUITextField : UITextField

@property BOOL error;
@property (copy, nonatomic)NSString * message;
@property (strong, nonatomic) AMPopTip* popTip;
@property (strong, nonatomic) UIImageView * imgViewError;

- (instancetype) init;
- (instancetype) initWithColor: (UIColor*) color;
- (id)initWithCoder:(NSCoder *)aDecoder;
- (void) leftViewIconImage:(NSString*)imageName;
- (void) setError:(BOOL)error message:(NSString*)msg;

@end
