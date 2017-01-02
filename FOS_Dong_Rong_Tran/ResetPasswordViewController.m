//
//  ResetPasswordViewController.m
//  FOS_Dong_Rong_Tran
//
//  Created by Huu Tran on 1/2/17.
//  Copyright © 2017 rjtcompuquest. All rights reserved.
//

#import "ResetPasswordViewController.h"
#import "SingleLineUITextField.h"

@interface ResetPasswordViewController ()


@property (weak, nonatomic) IBOutlet UIButton *resetButton;
@property (weak, nonatomic) IBOutlet SingleLineUITextField *mobileField;
@property (weak, nonatomic) IBOutlet SingleLineUITextField *passwordField;

@property (weak, nonatomic) IBOutlet SingleLineUITextField *confirmField;

@end



@implementation ResetPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.resetButton.layer.cornerRadius = self.resetButton.layer.frame.size.height/2;
    
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
#pragma mark - UITextFieldDelegate

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    // restore effect once editting
    [UIView animateWithDuration:0.4 animations:^{
        textField.transform = CGAffineTransformMakeScale(1.2, 1.2) ;
    } completion:^(BOOL finished) {
        textField.transform = CGAffineTransformIdentity;
    }];
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
@end
