//
//  FoodMenuTableViewCell.m
//  FOS_Dong_Rong_Tran
//
//  Created by Huu Tran on 1/2/17.
//  Copyright © 2017 rjtcompuquest. All rights reserved.
//

#import "FoodMenuTableViewCell.h"

@interface FoodMenuTableViewCell ()
@property (weak, nonatomic) IBOutlet UIView *cardView;
@end

@implementation FoodMenuTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.cardView setUserInteractionEnabled:NO];
    [self.cardView setAlpha:1];
    self.cardView.layer.masksToBounds = NO;
    self.cardView.layer.cornerRadius = 1;
    self.cardView.layer.shadowOffset = CGSizeMake(-.2f, .2f);
    self.cardView.layer.shadowRadius = 1;
    self.cardView.layer.shadowOpacity = 0.2;
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:self.cardView.bounds];
    self.cardView.layer.shadowPath = path.CGPath;
    self.backgroundColor = [UIColor colorWithRed:.9 green:.9 blue:.9 alpha:1];
    
    self.priceLabel.layer.cornerRadius = self.priceLabel.layer.frame.size.height/2;
    self.nameLabel.layer.cornerRadius = self.nameLabel.layer.frame.size.height/2;
    self.buyNowButton.layer.cornerRadius = self.buyNowButton.layer.frame.size.height/2;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
