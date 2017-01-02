//
//  RecentOrderViewController.m
//  FOS_Dong_Rong_Tran
//
//  Created by YIFU RONG on 1/1/17.
//  Copyright © 2017 rjtcompuquest. All rights reserved.
//

#import "RecentOrderViewController.h"
#import "RecentTableViewCell.h"

@interface RecentOrderViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic, strong)UIImageView *separatorLine;

@end

@implementation RecentOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

UIImageView* (^bottonLine)(void) = ^{
    UIImageView *view = [[UIImageView alloc] init];
    view.image = [UIImage imageNamed:@"bottonPage"];
    view.translatesAutoresizingMaskIntoConstraints = false;
    return view;
};

#pragma mark - Table View Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    RecentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RecentCell" forIndexPath:indexPath];
    
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
