//
//  SideBarTableViewController.m
//  ecommerce
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
        cell.textLabel.textColor = [UIColor darkTextColor];
        
        UIView * selectedView = [[UIView alloc] initWithFrame: CGRectMake(0.0, 0.0, cell.frame.size.width, cell.frame.size.height)];
        selectedView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
        
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
