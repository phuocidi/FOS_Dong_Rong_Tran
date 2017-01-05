//
//  SideBarTableViewController.m
//  FOS_Dong_Rong_Tran
//
//  Created by Huu Tran on 12/25/16.
//  Copyright © 2016 rjtcompuquest. All rights reserved.
//

#import "SideBarTableViewController.h"
//--------------------------------------
@interface SideBarTableViewController ()

@end

//--------------------------------------
@implementation SideBarTableViewController



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Incomplete implementation, return the number of sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete implementation, return the number of rows
    return [self.tableData count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"sidebarCell"];
    
    if(!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"sidebarCell"];
        
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.textLabel.font = [UIFont fontWithName:@"Georgia-Bold " size:22.0];
        UIView * selectedView = [[UIView alloc] initWithFrame: CGRectMake(0.0, 0.0, cell.frame.size.width, cell.frame.size.height)];
        
        
        // Madison 44, 62, 80
        selectedView.backgroundColor =[UIColor colorWithRed:44.0/255.0 green:62.0/255.0 blue:80.0/255.0 alpha:1];
        cell.selectedBackgroundView = selectedView;
    }
    
    cell.textLabel.text = self.tableData[indexPath.row];
    
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 45.0f;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.delegate sidebarControlDidSelectRow:indexPath];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end