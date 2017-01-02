//
//  OrderSummaryViewController.m
//  FOS_Dong_Rong_Tran
//
//  Created by YIFU RONG on 1/1/17.
//  Copyright © 2017 rjtcompuquest. All rights reserved.
//

#import "OrderSummaryViewController.h"
#import "FoodTableViewCell.h"
#import "SummaryTableViewCell.h"
#import "TotalTableViewCell.h"

@interface OrderSummaryViewController ()

@property(nonatomic, strong)UIImageView *separatorLine;
@property (weak, nonatomic) IBOutlet UIImageView *titleImageView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *DeliveryAddress;
- (IBAction)checkOut:(UIButton *)sender;

@end

@implementation OrderSummaryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)checkOut:(UIButton *)sender {
}

UIImageView* (^separatorView)(void) = ^{
    UIImageView *view = [[UIImageView alloc] init];
    view.image = [UIImage imageNamed:@"seperatorLine"];
    view.translatesAutoresizingMaskIntoConstraints = false;
    return view;
};

#pragma mark - Table View Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 1) {
        return 1;
    }
    if (section == 2) {
        return 1;
    }
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        SummaryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SummaryCell" forIndexPath:indexPath];
        return cell;
    }
    if (indexPath.section == 2) {
        TotalTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TotalCell" forIndexPath:indexPath];
        return cell;
    }
    
    FoodTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FoodCell" forIndexPath:indexPath];
    
    // Add separatorView
    self.separatorLine = separatorView();
    [cell addSubview:self.separatorLine];
    [self.separatorLine.centerXAnchor constraintEqualToAnchor:cell.centerXAnchor].active = true;
    [self.separatorLine.bottomAnchor constraintEqualToAnchor:cell.bottomAnchor].active = true;
    [self.separatorLine.heightAnchor constraintEqualToConstant:2].active = true;
    [self.separatorLine.widthAnchor constraintEqualToAnchor:cell.widthAnchor constant:-8].active = true;
    
    return cell;
}

#pragma mark - Table View Delegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        return 165.0f;
    }
    if (indexPath.section == 2) {
        return 50.0f;
    }
    return 80.0f;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    return 10.; // you can have your own choice, of course
//}
//
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    UIView *headerView = [[UIView alloc] init];
//    headerView.backgroundColor = [UIColor clearColor];
//    return headerView;
//}


@end








































