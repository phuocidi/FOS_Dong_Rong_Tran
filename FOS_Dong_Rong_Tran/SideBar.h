//
//  SideBar.h
//  ecommerce
//
//  Created by Huu Tran on 12/25/16.
//  Copyright © 2016 rjtcompuquest. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SideBarTableViewController.h"
#import "SideBarDelegate.h"
//------------------------------------



//------------------------------------
@interface SideBar : NSObject <SideBarTableViewControllerDelegate>

+ (instancetype) shareInstance;

-(instancetype) initWIthSourceView:(UIView*)sourceView menuItem:(NSArray*)menuItem;

@property (readwrite, nonatomic) CGFloat barWidth;
@property (readwrite,nonatomic) CGFloat sideBarTableViewTopInset;
@property (strong, nonatomic) UIView * sideBarContainerView;
@property (strong, nonatomic) SideBarTableViewController* sideBarTableViewController;
@property (strong, nonatomic) UIView* originView;
@property (strong, nonatomic) UIDynamicAnimator * animator;
@property (readwrite, nonatomic) BOOL isSideBarOpen;

@property (weak, nonatomic) id<SideBarDelegate> delegate;
@property (weak, nonatomic) UINavigationController * weakNavigationController;
@property (weak, nonatomic) UIStoryboard * weakStoryBoard;


@end
