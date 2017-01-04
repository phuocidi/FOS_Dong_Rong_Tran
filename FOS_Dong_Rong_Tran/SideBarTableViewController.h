//
//  SideBarTableViewController.h
//  ecommerce
//
//  Created by Huu Tran on 12/25/16.
//  Copyright © 2016 rjtcompuquest. All rights reserved.
//

#import <UIKit/UIKit.h>

//--------------------------------------
@protocol SideBarTableViewControllerDelegate <NSObject>

@required
-(void) sidebarControlDidSelectRow:(NSIndexPath*)indexPath;

@end

//--------------------------------------
@interface SideBarTableViewController : UITableViewController
//--------------------------------------
@property (weak, nonatomic) id <SideBarTableViewControllerDelegate> delegate;
@property (copy, nonatomic) NSArray* tableData;
@end
