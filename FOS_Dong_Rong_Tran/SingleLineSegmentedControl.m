//
//  SingleLineSegmentedControl.m
//  FOS_Dong_Rong_Tran
//
//  Created by Huu Tran on 1/2/17.
//  Copyright © 2017 rjtcompuquest. All rights reserved.
//

#import "SingleLineSegmentedControl.h"

@implementation SingleLineSegmentedControl

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)initWithItems:(NSArray *)items {
self = [super initWithItems:items];
if (self) {
// Initialization code

// Set divider images
    
    
//        NSDictionary *attributes = [NSDictionary dictionaryWithObject:font
//                                                               forKey:NSFontAttributeName];
//        [self.segmentedControl setTitleTextAttributes:attributes
//                                        forState:UIControlStateNormal];
    UIFont *font = [UIFont boldSystemFontOfSize:17.0f];
    
    UIColor *grayColor = [UIColor grayColor];
    NSDictionary *attributes = [NSDictionary dictionaryWithObjects:@[grayColor,font] forKeys:@[NSForegroundColorAttributeName,NSFontAttributeName]];
    [self setTitleTextAttributes:attributes
                               forState:UIControlStateNormal];
    
    UIColor *darkTextColor = [UIColor darkTextColor];
    NSDictionary *attributes2 = [NSDictionary dictionaryWithObjects:@[darkTextColor,font] forKeys:@[NSForegroundColorAttributeName,NSFontAttributeName]];
    [self setTitleTextAttributes:attributes2
                               forState:UIControlStateSelected];
    [self setTintColor:[UIColor clearColor]];
    
    [self setDividerImage:[UIImage imageNamed:@"segmentedNormal"] forLeftSegmentState:      UIControlStateNormal
        rightSegmentState:UIControlStateNormal
        barMetrics:UIBarMetricsDefault];

    [self setDividerImage:[UIImage imageNamed:@"segmentedNormal"]
      forLeftSegmentState:UIControlStateSelected
        rightSegmentState:UIControlStateNormal
        barMetrics:UIBarMetricsDefault];
    
    [self setDividerImage:[UIImage imageNamed:@"segmentedNormal"]
      forLeftSegmentState:UIControlStateNormal
        rightSegmentState:UIControlStateSelected
               barMetrics:UIBarMetricsDefault];
    
    // Set background images
    UIImage *normalBackgroundImage = [UIImage imageNamed:@"segmentedNormal"];
    
    [self setBackgroundImage:normalBackgroundImage
                    forState:UIControlStateNormal
                  barMetrics:UIBarMetricsDefault];
    
    UIImage *selectedBackgroundImage = [UIImage imageNamed:@"segmentedSelected"];
    [self setBackgroundImage:selectedBackgroundImage
                    forState:UIControlStateSelected
                  barMetrics:UIBarMetricsDefault];
    
    [self setTintColor: [UIColor clearColor]];
}
    return self;
}


@end
