//
//  SideBarDelegate.h
//  ecommerce
//
//  Created by Huu Tran on 1/3/17.
//  Copyright © 2017 rjtcompuquest. All rights reserved.
//
@protocol SideBarDelegate <NSObject>

@required
-(void) sideBarDidSelectButtonAtIndex:(NSUInteger)index;
@optional
- (void) sideBarWillClose;
- (void) sideBarWillOpen;


@end

#import <Foundation/Foundation.h>

