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
#import <CoreLocation/CoreLocation.h>

@interface OrderSummaryViewController () <UITextFieldDelegate>

@property(nonatomic, strong)UIImageView *separatorLine;
@property (weak, nonatomic) IBOutlet UIImageView *titleImageView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *DeliveryAddress;
@property (strong, nonatomic) CartModel *cartModel;
@property (strong, nonatomic) WebService *webService;
@property (strong, nonatomic) OrderDetailViewController *orderDetailVC;
@property (strong, nonatomic) NSMutableArray *cartList;
@property (strong, nonatomic) User *user;
@property (readwrite, nonatomic) double subTotal;
@property (readwrite, nonatomic) double tax;
@property (readwrite, nonatomic) double discount;
@property (readwrite, nonatomic) double deliveryCharges;
@property (readwrite, nonatomic) double containerCharges;
@property (readwrite, nonatomic) double orderTotal;
@property (weak, nonatomic) IBOutlet UIButton *checkOut;
@property (weak, nonatomic) IBOutlet UIButton *choosePaymentOptionsBtn;
@property (strong, nonatomic) UIView *paymentOptionsView;
@property (strong, nonatomic) NSMutableArray *orderIds;
// Paypal
@property (nonatomic, strong, readwrite) PayPalConfiguration *payPalConfiguration;


@end

@implementation OrderSummaryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.cartModel = [[CartModel alloc] init];
    self.cartList = [[NSMutableArray alloc] init];
    self.webService = [WebService sharedInstance];
    NSArray *allUsers = [self.cartModel allUsers];
    for (NSDictionary *dic in allUsers) {
        Cart *cart = [self createCartModel:dic];
        [self.cartList addObject:cart];
        NSLog(@"%@", dic);
    }
    self.user = [User sharedInstance];
    NSLog(@"lat: %f\n lon: %f",self.user.latitude, self.user.longitude);
    [self reverseLocation:self.user.latitude withLongitude:self.user.longitude];
    
    [self.choosePaymentOptionsBtn addTarget:self action:@selector(choosePaymentOptionButton:) forControlEvents:UIControlEventTouchUpInside];
    
    _payPalConfiguration = [[PayPalConfiguration alloc] init];
    _payPalConfiguration.acceptCreditCards = YES;
    _payPalConfiguration.merchantName = @"FOS";
    _payPalConfiguration.merchantPrivacyPolicyURL = [NSURL URLWithString:@"https://www.paypal.com/webapps/mpp/ua/privacy-full"];
    _payPalConfiguration.merchantUserAgreementURL = [NSURL URLWithString:@"https://www.paypal.com/webapps/mpp/ua/useragreement-full"];
    _payPalConfiguration.languageOrLocale = [NSLocale preferredLanguages][0];
    _payPalConfiguration.payPalShippingAddressOption = PayPalShippingAddressOptionPayPal;
    
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    
    [PayPalMobile preconnectWithEnvironment:PayPalEnvironmentNoNetwork];
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

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"CheckOut"]) {
        OrderDetailViewController *destinationVC = [segue destinationViewController];
        destinationVC.orderId = self.orderIds;
        [destinationVC setputTableView];
    }
    
}

#pragma mark - Create Payment Options

- (void)choosePaymentOptionButton:(UIButton *)sender {
    
    [UIView animateWithDuration:1 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        [self setupPaymentOptionsView];
    } completion:nil];
}

- (void)setupPaymentOptionsView {
    self.paymentOptionsView = [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2 -150, self.view.frame.size.height/2-75, 300, 150)];
    self.paymentOptionsView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0];
    [self.view addSubview:self.paymentOptionsView];
    
    UIButton *paypal = [UIButton buttonWithType:UIButtonTypeSystem];
    UIButton *payWithCash = [UIButton buttonWithType:UIButtonTypeSystem];
    UIButton *cancel =  [UIButton buttonWithType:UIButtonTypeSystem];
    
    [self.paymentOptionsView addSubview:paypal];
    [self.paymentOptionsView addSubview:payWithCash];
    [self.paymentOptionsView addSubview:cancel];
    
    [paypal.topAnchor constraintEqualToAnchor:self.paymentOptionsView.topAnchor constant:+4].active = true;
    [paypal.centerXAnchor constraintEqualToAnchor:self.paymentOptionsView.centerXAnchor].active = true;
    [paypal.widthAnchor constraintEqualToAnchor:self.paymentOptionsView.widthAnchor constant:-8].active = true;
    [paypal.heightAnchor constraintEqualToConstant:46].active = true;
    
    [payWithCash.centerXAnchor constraintEqualToAnchor:self.paymentOptionsView.centerXAnchor].active = true;
    [payWithCash.centerYAnchor constraintEqualToAnchor:self.paymentOptionsView.centerYAnchor].active = true;
    [payWithCash.widthAnchor constraintEqualToAnchor:self.paymentOptionsView.widthAnchor constant:-8].active = true;
    [payWithCash.heightAnchor constraintEqualToConstant:46].active = true;
    
    [cancel.bottomAnchor constraintEqualToAnchor:self.paymentOptionsView.bottomAnchor constant:-4].active = true;
    [cancel.centerXAnchor constraintEqualToAnchor:self.paymentOptionsView.centerXAnchor].active = true;
    [cancel.widthAnchor constraintEqualToAnchor:self.paymentOptionsView.widthAnchor constant:-8].active = true;
    [cancel.heightAnchor constraintEqualToConstant:46].active = true;
    
    [paypal setBackgroundImage:[UIImage imageNamed:@"PayPal"] forState:UIControlStateNormal];
    [payWithCash setBackgroundImage:[UIImage imageNamed:@"Cash"] forState:UIControlStateNormal];
    [cancel setBackgroundImage:[UIImage imageNamed:@"Cancel"] forState:UIControlStateNormal];
    
    paypal.translatesAutoresizingMaskIntoConstraints = false;
    payWithCash.translatesAutoresizingMaskIntoConstraints = false;
    cancel.translatesAutoresizingMaskIntoConstraints = false;
    
    paypal.tag = 1;
    payWithCash.tag = 2;
    cancel.tag = 3;
    
    [paypal addTarget:self action:@selector(paymentOptionsClicked:) forControlEvents:UIControlEventTouchUpInside];
    [payWithCash addTarget:self action:@selector(paymentOptionsClicked:) forControlEvents:UIControlEventTouchUpInside];
    [cancel addTarget:self action:@selector(paymentOptionsClicked:) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)paymentOptionsClicked:(UIButton *)sender {
    
    switch (sender.tag) {
        case 1:
            NSLog(@" Paypay");
            [self removePaymentOptionsView];
            [self payWithPayPal];
            break;
        case 2:
            NSLog(@" Pay With Cash");
            [self removePaymentOptionsView];
            [self payWithCashAlert];
            break;
        case 3:
            NSLog(@" Cancel");
            [self removePaymentOptionsView];
            break;
            
        default:
            break;
    }
    
}

- (void)removePaymentOptionsView {
    [UIView animateWithDuration:1 delay:0 options:UIViewAnimationOptionTransitionCurlUp animations:^{
        self.paymentOptionsView.frame = CGRectMake(self.view.frame.size.width, self.view.frame.size.height/2-75, 300, 150);
    } completion:nil];
}

- (void)removePaymentOptionsButton {
    [UIView animateWithDuration:1 animations:^{
        self.choosePaymentOptionsBtn.frame = CGRectMake(self.view.frame.size.width, self.choosePaymentOptionsBtn.frame.origin.y, self.choosePaymentOptionsBtn.frame.size.width, self.choosePaymentOptionsBtn.frame.size.height);
    }];
}

- (void)payWithCashAlert {
    UIAlertController* alert =
    [UIAlertController alertControllerWithTitle:@"Pay With Cash"
                                        message:@"Please Pay with Casher."
                                 preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* cancelAction =
    [UIAlertAction actionWithTitle:@"Cancel"
                             style:UIAlertActionStyleCancel
                           handler:nil];
    
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)payWithPayPal {
    NSMutableArray *itemsList = [[NSMutableArray alloc] init];
    for (Cart *cart in self.cartList) {
        NSString *price = [NSString stringWithFormat:@"%.2f", cart.price/cart.numberOfNeed];
        PayPalItem *item = [PayPalItem itemWithName:cart.name withQuantity:cart.numberOfNeed withPrice:[NSDecimalNumber decimalNumberWithString:price] withCurrency:@"USD" withSku:[NSString stringWithFormat:@"SKU-%@", cart.name]];
        [itemsList addObject:item];
    }
    
    NSDecimalNumber *subtotal = [PayPalItem totalPriceForItems:itemsList];
    NSDecimalNumber *shipping = [[NSDecimalNumber alloc] initWithString:@"0.00"];
    NSDecimalNumber *tax = [subtotal decimalNumberByMultiplyingBy:[[NSDecimalNumber alloc] initWithString:@"0.06"]];
    
    PayPalPaymentDetails *paymentDetails = [PayPalPaymentDetails paymentDetailsWithSubtotal:subtotal withShipping:shipping withTax:tax];
    NSDecimalNumber *total = [[subtotal decimalNumberByAdding:shipping] decimalNumberByAdding:tax];
    
    // Create a PayPalPayment
    PayPalPayment *payment = [[PayPalPayment alloc] init];
    
    // Amount, currency, and description
    payment.amount = total;
    payment.currencyCode = @"USD";
    payment.shortDescription = @"Food Ordering";
    payment.items = itemsList;
    payment.paymentDetails = paymentDetails;
    payment.payeeEmail = @"yr@gmail.com";
    
    payment.intent = PayPalPaymentIntentSale;
    
    //    payment.shippingAddress = address; // a previously-created PayPalShippingAddress object
    
    if (!payment.processable) {
        // If, for example, the amount was negative or the shortDescription was empty, then
        // this payment would not be processable. You would want to handle that here.
    }
    
    
    
    // Create a PayPalPaymentViewController.
    PayPalPaymentViewController *paymentViewController;
    paymentViewController = [[PayPalPaymentViewController alloc] initWithPayment:payment
                                                                   configuration:self.payPalConfiguration
                                                                        delegate:self];
    
    // Present the PayPalPaymentViewController.
    [self presentViewController:paymentViewController animated:YES completion:nil];
}

- (void)sendOrder {
    // Send Order
    self.orderIds = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < self.cartList.count; i ++) {
        Cart *cart = self.cartList[i];
        [self.webService sendOrderWithMobile:self.user.phone category:cart.category orderName:cart.name orderQuantity:[NSString stringWithFormat:@"%d", cart.numberOfNeed] totalCost:[NSString stringWithFormat:@"%.2f", cart.price] orderAddress:self.DeliveryAddress.text completionHandler:^(NSString *order_id) {
            NSLog(@"%@", order_id);
            [self.orderIds addObject:order_id];
            [self.tableView reloadData];
        }];
    }
    [self.cartModel deleteAllFood];
}

#pragma mark - PayPalPaymentDelegate methods

- (void)payPalPaymentViewController:(PayPalPaymentViewController *)paymentViewController
                 didCompletePayment:(PayPalPayment *)completedPayment {
    
    NSLog(@"Payment Success !!");
    // Payment was processed successfully; send to server for verification and fulfillment.
    //    [self verifyCompletedPayment:completedPayment];
    
    [self sendOrder];
    [self removePaymentOptionsButton];
    // Dismiss the PayPalPaymentViewController.
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)payPalPaymentDidCancel:(PayPalPaymentViewController *)paymentViewController {
    
    NSLog(@"Payment Cancel !!");
    // The payment was canceled; dismiss the PayPalPaymentViewController.
    
//    [self sendOrder];
//    [self removePaymentOptionsButton];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Reverse Geocode Location

- (void)reverseLocation:(double) latitude withLongitude:(double) longitude {
    CLLocation *newLocation = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if(error) {
            NSLog(@"geocode failed with error: %@", error);
            return;
            
        }
        if(placemarks && placemarks.count >0) {
            CLPlacemark *placemark = placemarks[0];
            NSDictionary *addressDictionary = placemark.addressDictionary;
            NSArray *addressLines = addressDictionary[@"FormattedAddressLines"];
            
            self.DeliveryAddress.text = [NSString localizedStringWithFormat:@"%@, %@, %@",addressLines[0], addressLines[1], addressLines[2]];
            
        }
    }];
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








































