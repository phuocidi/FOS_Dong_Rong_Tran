//
//  ResetPasswordViewController.m
//  FOS_Dong_Rong_Tran
//
//  Created by Huu Tran on 1/2/17.
//  Copyright © 2017 rjtcompuquest. All rights reserved.
//

#import "ResetPasswordViewController.h"
#import "SingleLineUITextField.h"
#import "LoginViewController.h"
#import "TWMessageBarManager.h"
#import "WebService.h"

@interface ResetPasswordViewController ()

{
    BOOL areFieldsValid;
}

@property (weak, nonatomic) IBOutlet UIButton *resetButton;
@property (weak, nonatomic) IBOutlet SingleLineUITextField *mobileField;
@property (weak, nonatomic) IBOutlet SingleLineUITextField *passwordField;

@property (weak, nonatomic) IBOutlet SingleLineUITextField *confirmField;

@end



@implementation ResetPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.resetButton.layer.cornerRadius = self.resetButton.layer.frame.size.height/2;
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    //CGFloat screenHeight = screenRect.size.height;
    UIToolbar * toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0.0f,0.0f,screenWidth,50.0f)];
    [toolbar setTintColor: [UIColor darkGrayColor]];
    
    UIBarButtonItem * doneBtn = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(userDidFinishEditingDatePickerField:)];
    // space bar
    UIBarButtonItem * space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    [toolbar setItems:[NSArray arrayWithObjects:space, doneBtn, nil]];
    
    // Customize keyboard
    [self.mobileField setInputAccessoryView:toolbar];
    
}

- (void) userDidFinishEditingDatePickerField:(id)sender {
    [self textFieldShouldReturn:self.mobileField];
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
    NSInteger nextTag = textField.tag + 1;
    // Try to find next responder
    UIResponder* nextResponder = [textField.superview viewWithTag:nextTag];
    if (nextResponder) {
        // Found next responder, so set it.
        [nextResponder becomeFirstResponder];
    } else {
        // Not found, so remove keyboard.
        [textField resignFirstResponder];
    }
    
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString * str = [NSString stringWithFormat:@"%@%@", textField.text, string];

    // Mobile phone length is 10-13
    if(textField.tag == 1 ){
        if(str.length <10 || str.length>13) {
            [(SingleLineUITextField*)textField setError:YES message:@"Mobile phone must contains 10-13 numbers"];
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
    
    // Check confirm password field
    if (textField.tag == 3) {
        NSString *regex = @"^(?=.{8,})(?=.*[0-9])(?=.*[a-zA-Z])([@#$%^&=a-zA-Z0-9_-]+)$";
        NSPredicate *passwordTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
        BOOL isValid = [passwordTest evaluateWithObject:textField.text];
        if(!isValid) {
            [(SingleLineUITextField*)textField setError:YES message:@"Need 8 characters, Must contain at least one lower case letter, one upper case letter, one digit and one special character"];
            areFieldsValid = NO;
            return YES;
        }
    }

    // General validation
    if (str.length < 3){
        [(SingleLineUITextField*)textField setError:YES message:@"Must contains more than 3 characters"];
        areFieldsValid = NO;
        return YES;
    }
    if ( [str containsString:@" "]) {
        [(SingleLineUITextField*)textField setError:YES message:@"Can not have space"];
            areFieldsValid = NO;
        return YES;
    }
    [(SingleLineUITextField*)textField setError:NO message:nil];
    areFieldsValid = YES;
    return YES;
}

- (IBAction)resetButtonClicked:(UIButton *)sender {
    LoginViewController * vc = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    if (areFieldsValid) {
        
        [[WebService sharedInstance] resetPassWordByPhone:self.mobileField.text oldPassword:self.passwordField.text newPassword:self.confirmField.text completionHandler:^(NSArray *data) {
            NSString * msg = (NSString *) data[0];
            if ([msg isEqualToString:@"password reset successfully"]){
                [self.navigationController pushViewController:vc animated:YES];
            }
            else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[TWMessageBarManager sharedInstance] showMessageWithTitle:@"ERROR"
                                                                   description:@"Cannot reset password"
                                                                          type:TWMessageBarMessageTypeError];
                });
            }
        }];
        
        
    
    }else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [[TWMessageBarManager sharedInstance] showMessageWithTitle:@"Invalide"
                                                           description:@"Please check if all inputs are correct"
                                                                  type:TWMessageBarMessageTypeError];
        });
    }
}

@end
