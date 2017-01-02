//
//  RecentTableViewCell.h
//  FOS_Dong_Rong_Tran
//
//  Created by YIFU RONG on 1/1/17.
//  Copyright © 2017 rjtcompuquest. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RecentTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *orderNumber;
@property (weak, nonatomic) IBOutlet UILabel *orderTime;
@property (weak, nonatomic) IBOutlet UILabel *totalPrice;
@property (weak, nonatomic) IBOutlet UILabel *orderStatus;

@end
