//
//  DetailSummaryTableViewCell.h
//  FOS_Dong_Rong_Tran
//
//  Created by YIFU RONG on 1/1/17.
//  Copyright © 2017 rjtcompuquest. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailSummaryTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *subTotal;
@property (weak, nonatomic) IBOutlet UILabel *tax;
@property (weak, nonatomic) IBOutlet UILabel *discount;
@property (weak, nonatomic) IBOutlet UILabel *deliveryCharges;
@property (weak, nonatomic) IBOutlet UILabel *containerCharges;

@end
