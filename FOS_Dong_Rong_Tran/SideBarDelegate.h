//
//  SideBarDelegate.h
//  FOS_Dong_Rong_Tran
//
//  Created by Huu Tran on 1/3/17.
//  Copyright © 2017 rjtcompuquest. All rights reserved.
//
@protocol SideBarDelegate <NSObject>

@optional
-(void) sideBarDidSelectButtonAtIndex:(NSUInteger)index;
- (void) sideBarWillClose;
- (void) sideBarWillOpen;


@end

#import <Foundation/Foundation.h>

