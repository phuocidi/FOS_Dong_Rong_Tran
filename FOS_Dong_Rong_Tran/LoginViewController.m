//
//  LoginViewController.m
//  FOS_Dong_Rong_Tran
//
//  Created by Huu Tran on 1/1/17.
//  Copyright © 2017 rjtcompuquest. All rights reserved.
//

#import "LoginViewController.h"
#import "SingleLineUITextField.h"
#import "HomeViewController.h"
#import "RegisterViewController.h"

@interface LoginViewController () <UITextFieldDelegate>
{
    BOOL areFieldsValid;
}
@property(weak, nonatomic) IBOutlet SingleLineUITextField * mobileField;
@property(weak, nonatomic) IBOutlet SingleLineUITextField * passwordField;
@property(weak, nonatomic) IBOutlet UIButton * doneButton;
@property(weak, nonatomic) IBOutlet UIButton * registerButton;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.mobileField.delegate = self;
    self.passwordField.delegate = self;
    
    self.mobileField.textColor = [UIColor whiteColor];
    self.passwordField.textColor = [UIColor whiteColor];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

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

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString * str = [NSString stringWithFormat:@"%@%@", textField.text, string];
    
    //Username /  Email field
    if (textField.tag == 1){
        // General validation
        if(str.length<10 || str.length>13){
            [(SingleLineUITextField*)textField setError:YES message:@"Mobile number must contains 10 to 13 numbers"];
            areFieldsValid = NO;
            return YES;
        }
    }
    // Check password field
    if (textField.tag == 2) {
        NSString *regex = @"^(?=.{8,})(?=.*[0-9])(?=.*[a-zA-Z])([@#$%^&=a-zA-Z0-9_-]+)$";
        
        NSPredicate *passwordTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
        
        BOOL isValid = [passwordTest evaluateWithObject:textField.text];
        if(!isValid) {
            [(SingleLineUITextField*)textField setError:YES message:@"Need 8 characters, Must contain at least one lower case letter, one upper case letter, one digit and one special character"];
            areFieldsValid = NO;
            return YES;
        }
        
    }
    
    [(SingleLineUITextField*)textField setError:NO message:nil];
    areFieldsValid = YES;
    return YES;
}



/*


// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark - Navigation
- (IBAction)doneButtonClick:(id)sender {
    // validate all field is not empty and push to navigation controller
    
    HomeViewController * vc = [self.storyboard instantiateViewControllerWithIdentifier:@"HomeViewController"];
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)registerButtonClick:(id)sender
{
    RegisterViewController * vc = [self.storyboard instantiateViewControllerWithIdentifier:@"RegisterViewController"];
    
    [self.navigationController pushViewController:vc animated:YES];
}

@end
