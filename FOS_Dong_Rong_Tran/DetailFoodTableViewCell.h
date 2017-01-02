//
//  DetailFoodTableViewCell.h
//  FOS_Dong_Rong_Tran
//
//  Created by YIFU RONG on 1/1/17.
//  Copyright © 2017 rjtcompuquest. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailFoodTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *foodName;
@property (weak, nonatomic) IBOutlet UILabel *foodPrice;
@property (weak, nonatomic) IBOutlet UILabel *numberOfNeed;


@end
