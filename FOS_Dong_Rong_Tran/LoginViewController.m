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
#import "ResetPasswordViewController.h"
#import "WebService.h"
#import "UserModel.h"

@interface LoginViewController () <UITextFieldDelegate>
{
    BOOL areFieldsValid;
}
@property(weak, nonatomic) IBOutlet SingleLineUITextField * mobileField;
@property(weak, nonatomic) IBOutlet SingleLineUITextField * passwordField;
@property(weak, nonatomic) IBOutlet UIButton * doneButton;
@property(weak, nonatomic) IBOutlet UIButton * rerestButton;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.mobileField.delegate = self;
    self.passwordField.delegate = self;
    
    self.mobileField.textColor = [UIColor whiteColor];
    self.passwordField.textColor = [UIColor whiteColor];
    
    self.doneButton.layer.cornerRadius = self.doneButton.layer.frame.size.height/2;
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITextFieldDelegate

-(void)textFieldDidBeginEditing:(SingleLineUITextField *)textField
{
    // restore effect once editting
    [UIView animateWithDuration:0.5 animations:^{
        textField.transform = CGAffineTransformMakeScale(1.1, 1.1) ;
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

- (BOOL) shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    BOOL __block tempBool = NO;
    if ([identifier isEqualToString:@"loginToHomeSegue"]) {
        
        [[WebService sharedInstance] loginByPhone:self.mobileField.text userPassword:self.passwordField.text completionHandler:^(BOOL successful) {
            tempBool= successful;
            UserModel * userModel = [[UserModel alloc] init];
            NSMutableArray* array =  [userModel allUsers];
        }];

    }
    return (tempBool)?tempBool:YES;
}

#pragma mark - Navigation


- (IBAction)resetButtonClick:(id)sender
{
    ResetPasswordViewController * vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ResetPasswordViewController"];
    
    [self.navigationController pushViewController:vc animated:YES];
}



@end
