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
    self.segmentedControl.frame = CGRectMake(10, 64, self.view.frame.size.width - 20, 35);
    self.segmentedControl.selectedSegmentIndex = 0;
    [self.segmentedControl addTarget:self action:@selector(handleSegmentControl:) forControlEvents: UIControlEventValueChanged];
    [self.view addSubview: self.segmentedControl];
    self.datasource = [NSMutableArray array];
    
    choice = [Constant foodKeyCategoryVeg];
    [self updateDatasource:[Constant foodKeyCategoryVeg]];
// need model to pass restaurant name

    self.navigationItem.title = @"Any Restaurant";
}

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
                              duration: 0.4f
                               options: UIViewAnimationOptionTransitionCrossDissolve
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
    
    //cell.buyNowButton.userInteractionEnabled = NO;
    //[cell.contentView addSubview: cell.buyNowButton];
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
    
//    [[ImageDownloader sharedInstance] fetchImage:urlStr completionHandler:^(NSData *image) {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            cell.foodImageView.image = [UIImage imageWithData:image];
//        });
//        
//    }];
    
    return cell;
}

- (void) orderButtonCicked: (UIButton*) sender {
    NSLog(@"sender.tag");
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
