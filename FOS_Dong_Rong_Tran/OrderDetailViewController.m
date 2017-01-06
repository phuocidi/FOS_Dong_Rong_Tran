//
//  OrderDetailViewController.m
//  FOS_Dong_Rong_Tran
//
//  Created by YIFU RONG on 1/1/17.
//  Copyright © 2017 rjtcompuquest. All rights reserved.
//

#import "OrderDetailViewController.h"
#import "DetailFoodTableViewCell.h"
#import "DetailSummaryTableViewCell.h"
#import "DetailTotalTableViewCell.h"
#import "Webservice.h"
#import "Cart.h"
#import <MapKit/MapKit.h>

@interface OrderDetailViewController ()

@property(nonatomic, strong)UIImageView *separatorLine;
@property (weak, nonatomic) IBOutlet MKMapView *map;
@property (weak, nonatomic) IBOutlet UILabel *deliveryAddress;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) WebService *webService;
@property (strong, nonatomic) NSMutableArray *shoppingList;
@property (readwrite, nonatomic) double subTotal;
@property (readwrite, nonatomic) double tax;
@property (readwrite, nonatomic) double discount;
@property (readwrite, nonatomic) double deliveryCharges;
@property (readwrite, nonatomic) double containerCharges;
@property (readwrite, nonatomic) double orderTotal;

@end

@implementation OrderDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)setputTableView {
    NSLog(@"%@", self.orderId);
    self.webService = [WebService sharedInstance];
    self.shoppingList = [[NSMutableArray alloc] init];
    for (int i = 0; i < self.orderId.count; i ++) {
        [self.webService checkComfirmID:self.orderId[i] completionHandler:^(NSArray *data) {
            Cart *cart = [self createCartModel:data[0]];
            [self.shoppingList addObject:cart];
            dispatch_async(dispatch_get_main_queue(), ^{
                self.deliveryAddress.text = cart.address;
                [self.tableView reloadData];
            });
        }];
    }
}

UIImageView* (^separatorV)(void) = ^{
    UIImageView *view = [[UIImageView alloc] init];
    view.image = [UIImage imageNamed:@"seperatorLine"];
    view.translatesAutoresizingMaskIntoConstraints = false;
    return view;
};

- (Cart *)createCartModel:(NSDictionary *) food {
    Cart *cart = [[Cart alloc] init];
    cart.date = food[@"OrderDate"];
    cart.name = [food[@"OrderName"] stringByReplacingOccurrencesOfString:@"%20" withString:@" "];
    cart.price = [food[@"TotalOrder"] intValue];
    cart.numberOfNeed = [food[@"OrderQuantity"] intValue];
    cart.address = [food[@"OrderDeliverAdd"] stringByReplacingOccurrencesOfString:@"%20" withString:@" "];
    return cart;
}

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
    return self.shoppingList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        self.subTotal = 0.0;
        self.tax = 0.0;
        self.discount = 0.0;
        self.deliveryCharges = 0.0;
        self.containerCharges = 0.0;
        DetailSummaryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SummaryCell" forIndexPath:indexPath];
        for (Cart *c in self.shoppingList) {
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
        DetailTotalTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TotalCell" forIndexPath:indexPath];
        self.orderTotal = self.subTotal + self.tax + self.discount + self.deliveryCharges + self.containerCharges;
        cell.totalPrice.text = [NSString stringWithFormat:@"%.2f", self.orderTotal];
        return cell;
    }
    
    DetailFoodTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FoodCell" forIndexPath:indexPath];
    
    Cart *cart = self.shoppingList[indexPath.row];
    cell.foodName.text = cart.name;
    double singlePrice = cart.price / cart.numberOfNeed;
    cell.foodPrice.text = [NSString stringWithFormat:@"%.2f", singlePrice];    cell.numberOfNeed.text = [NSString stringWithFormat:@"%d", cart.numberOfNeed];
    
    // Add separatorView
    self.separatorLine = separatorV();
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


@end
