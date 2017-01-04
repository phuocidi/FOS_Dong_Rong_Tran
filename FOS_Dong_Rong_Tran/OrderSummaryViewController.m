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
#import "SQLiteModel.h"
#import "CartModel.h"
#import "Cart.h"
#import "User.h"
#import "Webservice.h"
#import "OrderDetailViewController.h"

@interface OrderSummaryViewController () <UITextFieldDelegate>

@property(nonatomic, strong)UIImageView *separatorLine;
@property (weak, nonatomic) IBOutlet UIImageView *titleImageView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *DeliveryAddress;
// Remove later
@property (strong, nonatomic) SQLiteModel *sql;
@property (strong, nonatomic) CartModel *cartModel;
@property (strong, nonatomic) WebService *webService;
@property (strong, nonatomic) OrderDetailViewController *orderDetailVC;
@property (strong, nonatomic) NSMutableArray *cartList;
@property (readwrite, nonatomic) double subTotal;
@property (readwrite, nonatomic) double tax;
@property (readwrite, nonatomic) double discount;
@property (readwrite, nonatomic) double deliveryCharges;
@property (readwrite, nonatomic) double containerCharges;
@property (readwrite, nonatomic) double orderTotal;
@property (weak, nonatomic) IBOutlet UIButton *checkOut;


@end

@implementation OrderSummaryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.sql = [SQLiteModel sharedInstance];
    self.cartModel = [[CartModel alloc] init];
    self.cartList = [[NSMutableArray alloc] init];
    self.webService = [WebService sharedInstance];
    NSArray *allUsers = [self.cartModel allUsers];
    for (NSDictionary *dic in allUsers) {
        Cart *cart = [self createCartModel:dic];
        [self.cartList addObject:cart];
        NSLog(@"%@", dic);
    }
    
}

// Delete
- (IBAction)checkOut:(UIButton *)sender {
    // Send Order
    
    for (Cart *cart in self.cartList) {
        [self.webService sendOrderWithMobile:[NSString stringWithFormat:@"%d", cart.phone] category:cart.category orderName:cart.name orderQuantity:[NSString stringWithFormat:@"%d", cart.numberOfNeed] totalCost:[NSString stringWithFormat:@"%.2f", cart.price] orderAddress:self.DeliveryAddress.text completionHandler:^(NSString *order_id) {
            NSLog(@"%@", order_id);
        }];
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"CheckOut"]) {
        OrderDetailViewController *destinationVC = [segue destinationViewController];
        User *user = [User sharedInstance];
        // Send Order
        NSMutableArray *orderIds = [[NSMutableArray alloc] init];
        
        for (int i = 0; i < self.cartList.count; i ++) {
            Cart *cart = self.cartList[i];
            [self.webService sendOrderWithMobile:user.phone category:cart.category orderName:cart.name orderQuantity:[NSString stringWithFormat:@"%d", cart.numberOfNeed] totalCost:[NSString stringWithFormat:@"%.2f", cart.price] orderAddress:self.DeliveryAddress.text completionHandler:^(NSString *order_id) {
                NSLog(@"%@", order_id);
                [orderIds addObject:order_id];
                if (i == self.cartList.count - 1) {
                    destinationVC.orderId = orderIds;
                    [destinationVC setputTableView];
                }
            }];
        }
        [self.cartModel deleteAllFood];
    }
    
}

- (void)changeNumberOfNeed:(UIButton *)sender {
    Cart *cart = [self.cartList objectAtIndex:sender.tag];
    double singlePrice = cart.price / cart.numberOfNeed;
    if ([sender.titleLabel.text isEqualToString:@"1"]) {
        cart.numberOfNeed -= 1;
        cart.price -= singlePrice;
        // update database
        [self.cartModel saveUser:cart];
        if (cart.numberOfNeed == 0) {
            [self.cartList removeObjectAtIndex:sender.tag];
            // update database
            [self.cartModel deleteUser:cart];
        }
        [self.tableView reloadData];
    } else {
        cart.numberOfNeed += 1;
        cart.price += singlePrice;
        // update database
        [self.cartModel saveUser:cart];
        [self.tableView reloadData];
    }
}

- (Cart *)createCartModel:(NSDictionary *) food {
    Cart *cart = [[Cart alloc] init];
    cart.id = [food[@"id"] intValue];
    cart.category = food[@"food_category"];
    cart.date = food[@"food_date"];
    cart.name = food[@"food_name"];
    cart.price = [food[@"food_price"] intValue];
    cart.numberOfNeed = [food[@"numberOfNeed"] intValue];
    return cart;
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
    return self.cartList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        self.subTotal = 0.0;
        self.tax = 0.0;
        self.discount = 0.0;
        self.deliveryCharges = 0.0;
        self.containerCharges = 0.0;
        SummaryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SummaryCell" forIndexPath:indexPath];
        for (Cart *c in self.cartList) {
            Cart *cart = c;
            self.subTotal += cart.price;
        }
        self.tax = self.subTotal * 0.06;
        cell.subTotal.text = [NSString stringWithFormat:@"%.2f", self.subTotal];
        cell.tax.text = [NSString stringWithFormat:@"%.2f", self.tax];
        return cell;
    }
    if (indexPath.section == 2) {
        self.orderTotal = 0.0;
        TotalTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TotalCell" forIndexPath:indexPath];
        self.orderTotal = self.subTotal + self.tax + self.discount + self.deliveryCharges + self.containerCharges;
        cell.totalPrice.text = [NSString stringWithFormat:@"%.2f", self.orderTotal];
        return cell;
    }
    
    FoodTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FoodCell" forIndexPath:indexPath];
    
    Cart *cart = self.cartList[indexPath.row];
    cell.foodName.text = cart.name;
    double singlePrice = cart.price / cart.numberOfNeed;
    cell.foodPrice.text = [NSString stringWithFormat:@"%.2f", singlePrice];
    cell.numberOfNeed.delegate = self;
    cell.numberOfNeed.tag = [indexPath row];
    cell.numberOfNeed.text = [NSString stringWithFormat:@"%d", cart.numberOfNeed];
    
    [cell.minus addTarget:self action:@selector(changeNumberOfNeed:) forControlEvents:UIControlEventTouchUpInside];
    cell.minus.tag = [indexPath row];
    [cell.add addTarget:self action:@selector(changeNumberOfNeed:) forControlEvents:UIControlEventTouchUpInside];
    cell.add.tag = [indexPath row];
    
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

#pragma mark - TextField Delegate

-(void)textFieldDidEndEditing:(UITextField *)textField {
    NSLog(@"%@", textField.text);
    [textField resignFirstResponder];
    Cart *cart = [self.cartList objectAtIndex:textField.tag];
    double singlePrice = cart.price / cart.numberOfNeed;
    cart.numberOfNeed = [textField.text intValue];
    cart.price = cart.numberOfNeed * singlePrice;
    [self.cartModel saveUser:cart];
    if (cart.numberOfNeed == 0) {
        [self.cartList removeObjectAtIndex:textField.tag];
        // update database
        [self.cartModel deleteUser:cart];
    }
    [self.tableView reloadData];
}

@end








































