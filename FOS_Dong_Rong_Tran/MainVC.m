//
//  MainVC.m
//  FOS_Dong_Rong_Tran
//
//  Created by Huu Tran on 1/5/17.
//  Copyright © 2017 rjtcompuquest. All rights reserved.
//

#import "MainVC.h"

@interface MainVC ()

@end

@implementation MainVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (NSString*) segueIdentifierForIndexPathInLeftMenu:(NSIndexPath *)indexPath {
    NSString * identifier;
    switch (indexPath.row) {
        case 0:
            identifier = @"homePageSegue";
            break;
        case 1:
            identifier = @"foodMenuSegue";
            break;
        case 2:
            identifier = @"orderSummarySegue";
            break;
        case 3:
            identifier = @"checkOutSegue";
            break;
        case 4:
            identifier = @"orderHistorySegue";
            break;
    }
    
    return identifier;
}

- (void) configureLeftMenuButton:(UIButton *)button {
    button.frame = CGRectMake(4, 4, 40, 40);
    [button setImage:[UIImage imageNamed:@"menu"] forState:UIControlStateNormal];
    [button setTintColor:[UIColor whiteColor]];
}

- (BOOL)deepnessForLeftMenu
{
    return YES;
}

- (void) configureSlideLayer:(CALayer *)layer {
    layer.shadowOffset = CGSizeMake(-0.5f, 0.5f);
}


@end
