//
//  SideBar.m
//  ecommerce
//
//  Created by Huu Tran on 12/25/16.
//  Copyright © 2016 rjtcompuquest. All rights reserved.
//

#import "SideBar.h"
#import "AppDelegate.h"
//-----------------------------
@interface SideBar ()


@end

//-----------------------------
@implementation SideBar


-(instancetype ) init {
    if(self==[super init]){
        self.barWidth = 150.0;
        self.sideBarTableViewTopInset= 65.0;
        self.sideBarContainerView = [[UIView alloc] init];
        self.sideBarTableViewController = [[SideBarTableViewController alloc] init];
        self.originView = [[UIView alloc] init];
        self.animator = [[UIDynamicAnimator alloc] init];
        self.isSideBarOpen = NO;
    }
    return self;
}

-(instancetype) initWIthSourceView:(UIView*)sourceView menuItem:(NSArray*)menuItem {
    if(self==[super init]){
        self.barWidth = 150.0;
        self.sideBarTableViewTopInset= 65.0;
        self.sideBarContainerView = [[UIView alloc] init];
        self.sideBarTableViewController = [[SideBarTableViewController alloc] init];
        self.sideBarTableViewController.tableData = menuItem;
        self.originView = sourceView;
        
        [self setUpSideBar];
        self.animator = [[UIDynamicAnimator alloc] initWithReferenceView: self.originView];
        self.isSideBarOpen = NO;
        
        // add swipe right to open, left to close gesture
        UISwipeGestureRecognizer * showGestureRegconizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
        showGestureRegconizer.direction = UISwipeGestureRecognizerDirectionRight;
        [self.originView addGestureRecognizer:showGestureRegconizer];
        
        UISwipeGestureRecognizer * hideGestureRegconizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
        hideGestureRegconizer.direction = UISwipeGestureRecognizerDirectionLeft;
        [self.originView addGestureRecognizer:hideGestureRegconizer];
        
    }
    return self;
}


- (void) setUpSideBar {
    self.sideBarContainerView.frame = CGRectMake(-self.barWidth-1, self.originView.frame.origin.y, self.barWidth, self.originView.frame.size.height);
    self.sideBarContainerView.backgroundColor = [UIColor clearColor];
    self.sideBarContainerView.clipsToBounds = NO;
    [self.originView addSubview:self.sideBarContainerView];
    UIVisualEffectView * blurView = [[UIVisualEffectView alloc] initWithEffect: [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
    blurView.frame = self.sideBarContainerView.bounds;
    [self.sideBarContainerView addSubview:blurView];
    
    //
    self.sideBarTableViewController.delegate = self;
    self.sideBarTableViewController.tableView.frame = self.sideBarContainerView.bounds;
    self.sideBarTableViewController.tableView.clipsToBounds = NO;
    self.sideBarTableViewController.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.sideBarTableViewController.tableView.backgroundColor = [UIColor clearColor];
    self.sideBarTableViewController.tableView.scrollsToTop = NO;
    self.sideBarTableViewController.tableView.contentInset = UIEdgeInsetsMake(self.sideBarTableViewTopInset, 0, 0, 0);
    
    // reload data to display
    [self.sideBarTableViewController.tableView reloadData];
    [self.sideBarContainerView addSubview:self.sideBarTableViewController.tableView];
}

- (void) handleSwipe: (UISwipeGestureRecognizer*)recognizer{
    if (recognizer.direction == UISwipeGestureRecognizerDirectionLeft) {
        [self showSideBar:NO];
        [self.delegate sideBarWillClose];
        return;
    }
    
    if (recognizer.direction == UISwipeGestureRecognizerDirectionRight) {
        [self showSideBar:YES];
        [self.delegate sideBarWillOpen];
        return;
    }
}

- (void) showSideBar:(BOOL)shouldOpen {
    
    [self.animator removeAllBehaviors];
    self.isSideBarOpen = shouldOpen;
    
    CGFloat gravityX = (shouldOpen)? 0.5 : -0.5;
    CGFloat magtitute =(shouldOpen)? 20 : -20;
    CGFloat boundaryX =(shouldOpen)? self.barWidth : (- self.barWidth - 1);
    
    UIGravityBehavior *gravityBehavior = [[UIGravityBehavior alloc] initWithItems:@[self.sideBarContainerView]];
    gravityBehavior.gravityDirection = CGVectorMake(gravityX, 0);
    [self.animator addBehavior:gravityBehavior];
    
    UICollisionBehavior * collisionBehavior = [[UICollisionBehavior alloc] initWithItems:@[self.sideBarContainerView]];
    [collisionBehavior addBoundaryWithIdentifier:@"sideBarBoundary" fromPoint:CGPointMake(boundaryX, 20) toPoint:CGPointMake( boundaryX ,self.originView.frame.size.height)];
    [self.animator addBehavior:collisionBehavior];
    
    
    UIPushBehavior * pushBehavior = [[UIPushBehavior alloc] initWithItems:@[self.sideBarContainerView] mode:UIPushBehaviorModeInstantaneous];
    pushBehavior.magnitude = magtitute;
    [self.animator addBehavior:pushBehavior];
    
    UIDynamicItemBehavior * sideBarBehavior = [[UIDynamicItemBehavior alloc] initWithItems:@[self.sideBarContainerView]];
    sideBarBehavior.elasticity = 0.3;
    [self.animator addBehavior:sideBarBehavior];
}

-(void) sidebarControlDidSelectRow:(NSIndexPath *)indexPath {
    NSLog(@"SIDE_BAR: indexPath: %ld", indexPath.row );
    
    [self.weakNavigationController popToRootViewControllerAnimated:NO];
    
    ViewController *  vc0 = [self.weakStoryBoard instantiateViewControllerWithIdentifier:@"ViewController"];
     
    ShoppingCartTableViewController * vc1 = [self.weakStoryBoard instantiateViewControllerWithIdentifier:@"ShoppingCartTableViewController"];

    OrderHistoryTableViewController *vc2 = [self.weakStoryBoard instantiateViewControllerWithIdentifier:@"OrderHistoryTableViewController"];

    
    if(indexPath.row == 0) {
        //[self.weakNavigationController pushViewController:vc0 animated:YES];
        [self.weakNavigationController popToRootViewControllerAnimated:YES];
    }else if (indexPath.row == 1) {
        [self.weakNavigationController pushViewController:vc1 animated:YES];
    }else if (indexPath.row == 2) {
        [self.weakNavigationController pushViewController:vc1 animated:NO];
        [self.weakNavigationController pushViewController:vc2 animated:YES];
    }else{
        
    }
    
    //[self.delegate sideBarDidSelectButtonAtIndex:indexPath.row];
}

@end
