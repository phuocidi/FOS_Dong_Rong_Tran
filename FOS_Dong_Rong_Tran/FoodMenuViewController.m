//
//  FoodMenuViewController.m
//  FOS_Dong_Rong_Tran
//
//  Created by Huu Tran on 1/2/17.
//  Copyright © 2017 rjtcompuquest. All rights reserved.
//

#import "FoodMenuViewController.h"
#import "FoodMenuTableViewCell.h"
#import "SingleLineSegmentedControl.h"
#import "Webservice.h"
#import "Constant.h"
#import "ImageDownloader.h"
#import "OrderSummaryViewController.h"
#import "CartModel.h"
#import  "UIViewController+AMSlideMenu.h"
#import "RestaurantManager.h"
#import "TWMessageBarManager.h"

// --------------------------------
@interface FoodMenuViewController () <UITableViewDelegate, UITableViewDataSource>
{
        NSString * choice;
    
}
@property (weak, nonatomic) IBOutlet UITableView * tableView;
@property (strong, nonatomic) SingleLineSegmentedControl * segmentedControl;
@property (retain, nonatomic) NSMutableArray * datasource;
@end

// --------------------------------
@implementation FoodMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.separatorColor = [UIColor clearColor];
    
    NSArray *items = @[@"Veg menu", @"Non-veg menu"];
    self.segmentedControl = [[SingleLineSegmentedControl alloc] initWithItems:items];
    self.segmentedControl.frame = CGRectMake(10, 40, self.view.frame.size.width-20, 40);
    self.segmentedControl.selectedSegmentIndex = 0;
    [self.segmentedControl addTarget:self action:@selector(handleSegmentControl:) forControlEvents: UIControlEventValueChanged];
    
    [self.view addSubview: self.segmentedControl];
    
    // supress tableview top margin spaces
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.datasource = [NSMutableArray array];
    choice = [Constant foodKeyCategoryVeg];
    [self updateDatasource:[Constant foodKeyCategoryVeg]];

    // TODO: need model to pass restaurant name

    self.navigationItem.title = ([RestaurantManager sharedInstance].currentRestaurant)? [RestaurantManager sharedInstance].currentRestaurant.name : @"";

}

#pragma mark - segmented control
- (void) handleSegmentControl:(UISegmentedControl*)sender {

    switch (sender.selectedSegmentIndex) {
        case 0:
            choice = [Constant foodKeyCategoryVeg];
            break;
        case 1:
            choice = [Constant foodKeyCategoryNonVeg];
            break;
    }
    
    [self updateDatasource:choice];
    

}

- (void) updateDatasource:(NSString*) choice {
    [[WebService sharedInstance] getFoodMenu:choice completionHandler:^(NSArray *data) {
        self.datasource = [NSMutableArray arrayWithArray: data];
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [UIView transitionWithView: self.tableView
                              duration: 0.8f
                               options: UIViewAnimationOptionTransitionCurlUp
                            animations: ^(void)
             {
                 [self.tableView reloadData];
             }
                            completion: nil];
        });
    }];
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
    
    return self.datasource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FoodMenuTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"foodMenuCell"];
    // dummy cell if empty
    
    cell.buyNowButton.tag = indexPath.row;
    [cell.buyNowButton addTarget:self action:@selector(orderButtonCicked:) forControlEvents: UIControlEventTouchUpInside];
    
    [cell.buyNowButton setTitleColor:[UIColor darkGrayColor]
                   forState:UIControlStateHighlighted];

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSDictionary * item = (NSDictionary *) self.datasource[indexPath.row];
    dispatch_async(dispatch_get_main_queue(), ^{
            cell.priceTag.titleLabel.text = [NSString stringWithFormat:@"$%ld", [item[[Constant foodKeyPrice]] integerValue]];
    });

    cell.nameLabel.text = item[[Constant foodKeyName]];
    cell.recepieeLabel.text = item [[Constant foodKeyRecepiee]];
    
    NSString * urlStr = item[[Constant foodKeyImgURL]];

    [[ImageDownloader sharedInstance] downloadImageForCellwithURL:[NSURL URLWithString:urlStr]
                                                completionHandler:^(UIImage *image) {
                                                   
                                                    dispatch_async(dispatch_get_main_queue(), ^{
                                                        if (image) {
                                                           cell.foodImageView.image = image;
                                                        }
                                                        else {
                                                            cell.foodImageView.image = [UIImage imageNamed:@"Food"];
                                                        }
                                                   });
                                                }];
    return cell;
}

- (void) orderButtonCicked: (UIButton*) sender {
    NSLog(@"sender.tag");

        [[TWMessageBarManager sharedInstance] showMessageWithTitle:@"Sucess"
                                                       description:@"order is placed"
                                                              type:TWMessageBarMessageTypeSuccess];

    [UIView animateWithDuration:0.2 animations:^{
        sender.transform = CGAffineTransformMakeScale(1.1, 1.1);
    } completion:^(BOOL finished) {
        sender.transform = CGAffineTransformIdentity;
    }];
    
    NSDictionary * item = [self.datasource objectAtIndex:sender.tag];
    NSString* add = @"Chicago";
    
    NSDateFormatter * dateFormatter  = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd hh:mm:ss"];
    NSDate * now = [NSDate date];
    NSString * dateStr = [NSString stringWithFormat:@"%@", [dateFormatter stringFromDate:now]];
    
    
    CartModel * cartModel = [[CartModel alloc] init];
    [cartModel createCart:[item[[Constant foodKeyID]] intValue] name:item[[Constant foodKeyName]] category:choice add:add number:1 date:dateStr price:[item[[Constant foodKeyPrice]] doubleValue] ];
}

#pragma mark - UITableViewDelegate
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 350.0;
}
- (IBAction)toSummary:(id)sender {
    
    AMSlideMenuMainViewController *mainVC = [self mainSlideMenu];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:4 inSection:0];
    [mainVC openContentViewControllerForMenu:AMSlideMenuLeft atIndexPath:indexPath];
}

@end
