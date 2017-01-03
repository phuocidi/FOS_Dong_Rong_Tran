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
    
    //[self.contentView setUserInteractionEnabled:NO];
    
    //[self.cardView setUserInteractionEnabled:NO];
    [self.cardView setAlpha:1];
    self.cardView.layer.masksToBounds = YES;
    self.cardView.layer.cornerRadius = 1;
    self.cardView.layer.shadowOffset = CGSizeMake(-.4f, .4f);
    self.cardView.layer.shadowRadius = 1;
    self.cardView.layer.shadowOpacity = 0.5;
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:self.cardView.bounds];
    self.cardView.layer.shadowPath = path.CGPath;
    self.backgroundColor = [UIColor colorWithRed:.9 green:.9 blue:.9 alpha:1];
    
    //self.priceLabel.layer.cornerRadius = self.priceLabel.layer.frame.size.height/2;
    self.priceTag.userInteractionEnabled = NO;
    [self.priceTag setBackgroundImage:[UIImage imageNamed:@"pricetag"] forState:UIControlStateNormal];
    self.buyNowButton.layer.cornerRadius = self.buyNowButton.layer.frame.size.height/2;
    //self.buyNowButton.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
