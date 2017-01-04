//
//  RecentOrderViewController.m
//  FOS_Dong_Rong_Tran
//
//  Created by YIFU RONG on 1/1/17.
//  Copyright © 2017 rjtcompuquest. All rights reserved.
//

#import "RecentOrderViewController.h"
#import "RecentTableViewCell.h"
#import "User.h"
#import "Webservice.h"
#import "Cart.h"

@interface RecentOrderViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic, strong)UIImageView *separatorLine;
@property (strong, nonatomic) WebService *webService;
@property (strong, nonatomic) NSMutableArray *recentOrderList;

@end

@implementation RecentOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    self.webService = [WebService sharedInstance];
    self.recentOrderList = [[NSMutableArray alloc] init];
    User *user = [User sharedInstance];
    
    [self.webService checkOrderHistoryWithMobile:user.phone completionHandler:^(NSArray *data) {
        for (int i = 0; i < data.count; i ++) {
            Cart *cart = [self createCartModel:data[i]];
            [self.recentOrderList addObject:cart];
            if (i == data.count - 1) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableView reloadData];
                });
            }
        }
        
        
    }];

    
}

UIImageView* (^bottonLine)(void) = ^{
    UIImageView *view = [[UIImageView alloc] init];
    view.image = [UIImage imageNamed:@"bottonPage"];
    view.translatesAutoresizingMaskIntoConstraints = false;
    return view;
};

- (Cart *)createCartModel:(NSDictionary *) food {
    Cart *cart = [[Cart alloc] init];
    cart.date = food[@"OrderDate"];
    cart.name = [food[@"OrderName"] stringByReplacingOccurrencesOfString:@"%20" withString:@" "];
    cart.price = [food[@"TotalOrder"] intValue];
    cart.numberOfNeed = [food[@"OrderQuantity"] intValue];
    cart.orderId = [food[@"OrderId"] intValue];
    cart.orderStatus = food[@"OrderStatus"];
    return cart;
}

#pragma mark - Table View Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.recentOrderList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    RecentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RecentCell" forIndexPath:indexPath];
    
    Cart *cart = self.recentOrderList[indexPath.row];
    cell.orderNumber.text = [NSString stringWithFormat:@"%d", cart.orderId];
    cell.totalPrice.text = [NSString stringWithFormat:@"%.2f", cart.price];
    cell.orderTime.text = cart.date;
    switch ([cart.orderStatus intValue]) {
        case 1:
            cell.orderStatus.text = @"Packing";
            break;
        case 2:
            cell.orderStatus.text = @"On the way";
            break;
        case 3:
            cell.orderStatus.text = @"Delivered";
            break;
            
        default:
            break;
    }
    
    // Add separatorView
    self.separatorLine = bottonLine();
    [cell addSubview:self.separatorLine];
    [self.separatorLine.centerXAnchor constraintEqualToAnchor:cell.centerXAnchor].active = true;
    [self.separatorLine.bottomAnchor constraintEqualToAnchor:cell.bottomAnchor].active = true;
    [self.separatorLine.heightAnchor constraintEqualToConstant:2].active = true;
    [self.separatorLine.widthAnchor constraintEqualToAnchor:cell.widthAnchor constant:-8].active = true;
    
    return cell;
}

#pragma mark - Table View Delegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100.0f;
}

@end
