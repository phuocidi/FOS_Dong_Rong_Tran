//
//  FoodMenuViewController.m
//  FOS_Dong_Rong_Tran
//
//  Created by Huu Tran on 1/2/17.
//  Copyright © 2017 rjtcompuquest. All rights reserved.
//

#import "FoodMenuViewController.h"
#import "FoodTableViewCell.h"
#import "SingleLineSegmentedControl.h"

// --------------------------------
@interface FoodMenuViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView * tableView;

@end

// --------------------------------
@implementation FoodMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.separatorColor = [UIColor clearColor];
    
    
    NSArray *items = @[@"Veg menu", @"Non-veg menu"];
    SingleLineSegmentedControl *mySegmentedControl = [[SingleLineSegmentedControl alloc] initWithItems:items];
    mySegmentedControl.frame = CGRectMake(10, 64, self.view.frame.size.width - 20, 35);
    mySegmentedControl.selectedSegmentIndex = 0;
    [self.view addSubview:mySegmentedControl];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FoodTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"foodMenuCell"];
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 350.0;
}

@end
