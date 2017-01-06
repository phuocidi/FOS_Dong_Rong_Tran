//
//  MainVC.m
//  FOS_Dong_Rong_Tran
//
//  Created by Huu Tran on 1/5/17.
//  Copyright © 2017 rjtcompuquest. All rights reserved.
//

#import "MainVC.h"
#import  "UIViewController+AMSlideMenu.h"
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
        case 1:
            identifier = @"homePageSegue";
            break;
        case 2:
            identifier = @"foodMenuSegue";
            break;
        case 3:
            identifier = @"orderSummarySegue";
            break;
        case 4:
            identifier = @"checkOutSegue";
            break;
        case 5:
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
    
    AMSlideMenuMainViewController *mainVC = [self mainSlideMenu];
    
    layer.shadowColor = [[UIColor whiteColor] CGColor];
    layer.shadowOffset = CGSizeMake(0.0f,0.0f);
    layer.shadowOpacity = 1.0f;
    layer.shadowRadius = 4.0f;
    CGRect shadowRect = CGRectInset(mainVC.leftMenu.view.bounds, -4, -50);  // inset top/bottom
    layer.shadowPath = [[UIBezierPath bezierPathWithRect:shadowRect] CGPath];
}

- (CGFloat)maxDarknessWhileLeftMenu {
    return 0.4;
}


@end
