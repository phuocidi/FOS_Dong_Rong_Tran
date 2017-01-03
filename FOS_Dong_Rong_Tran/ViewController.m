//
//  ViewController.m
//  FOS_Dong_Rong_Tran
//
//  Created by Huu Tran on 12/30/16.
//  Copyright © 2016 rjtcompuquest. All rights reserved.
//

#import "ViewController.h"
#import "WebService.h"
#import "Constant.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
//    [[WebService sharedInstance] getCategory:[Constant foodKeyCategoryNonVeg] completionHandler:^(NSArray * data) {
//        NSLog(@"%@", data);
//    }];
    
//    [[WebService sharedInstance] sendOrderWithMobile:@"7777777777" category:@"veg" orderName:@"meal" orderQuantity:@"7" totalCost:@"333" orderAddress:@"chitown" completionHandler:^(NSString *order_id) {
//        NSLog(@"%@", order_id);
//    }];
    
//    [[WebService sharedInstance] checkOrderHistoryWithMobile:@"7777777777" completionHandler:^(NSArray *data) {
//        NSLog(@"%@", data);
//    }];
    
//    [[WebService sharedInstance] checkOrderStatusID:@"12222254" completionHandler:^(NSArray *data) {
//        NSLog(@"%@", data);
//    }];
    

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
